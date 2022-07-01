require 'date'

class ProductsController < ApplicationController
  def index
    items =
      if params[:month].present?
        month_number = Date::MONTHNAMES.index(params[:month].capitalize)
        month_number_string = "%02d" % month_number
        Item.where("strftime('%m', created_at) = ?", month_number_string)
      else
        Item.all
      end
    @products = items.map { |item| item.price = price(item); item }
  end

  private

  def price(item)
    price =
      case item.kind
      when 'book'
        if isbn_repository[item.isbn].present?
          isbn_repository[item.isbn][:price].to_f
        elsif item.is_hot && Time.now.on_weekday?
          9.99
        else
          (item.purchase_price || ENV['BOOK_PURCHASE_PRICE'].to_f) * 1.25
        end
      when 'image'
        if item.source == 'NationalGeographic'
          image_resolution(item) * 0.02 / 9600
        elsif item.source == 'Getty'
          if item.format == 'raw'
            10
          elsif image_resolution(item) <= 1280 * 720
            1
          elsif image_resolution(item) <= 1920 * 1080
            3
          else
            5
          end
        else
          7
        end
      when 'video'
        case item.quality
        when '4k'
          0.08 * item.duration.seconds.to_f
        when 'FullHD'
          3 * started_minutes(item)
        when 'SD'
          [started_minutes(item), 10].min
        else
          15
        end
      else
        raise NotImplementedError, "unknown product kind: #{item.kind}"
      end

    if item.kind == 'video'
      price = Time.now.hour.between?(5, 21) ? price : price * 0.6
      price = item.title.downcase.include?('premium') ? price * 1.05 : price
    end
    if item.kind == 'book'
      price = item.title.downcase.include?('premium') ? price * 1.05 : price
    end
    price
  end

  def started_minutes(video)
    1 + video.duration / 60
  end

  def image_resolution(image)
    image.height * image.width
  end

  def isbn_repository
    repository_file_path = Rails.root.join('app/assets/config/isbn_prices.csv')
    return {} unless File.exist?(repository_file_path)
    @_isbn_repository ||= CSV.read(repository_file_path, headers: true, header_converters: :symbol)
                             .index_by { |entry| entry[:isbn] }
  end

end
