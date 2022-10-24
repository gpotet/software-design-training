# frozen_string_literal: true
module Purchaser
  def compute_price(item, buy: true)
    case item.kind
    when 'book'
      if isbn_repository[item.isbn].present?
        price = isbn_repository[item.isbn][:price].to_f
      else
        price = (item.purchase_price || ENV['BOOK_PURCHASE_PRICE'].to_f) * 1.25
      end
    when 'image'
      if item.source == 'NationalGeographic'
        price = image_resolution(item) * 0.02 / 9600
      elsif item.source == 'Getty'
        price =
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
        price = 7
      end
      if premium? && image_resolution(item) > 1920 * 1080
        price = price * 0.9
      end
    when 'video'
      price =
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
      if premium? && item.quality == '4k'
        price = price * 0.9
      end
    else
      raise NotImplementedError, "unknown product kind: #{item.kind}"
    end

    invoice = ProductInvoice.new(item: item, user: current_user, title: item.title, price: price)
    if buy
      already_in_library = Download.where(item: @product, user: current_user).any?
      if already_in_library
        return render plain: "Product is already in the library of #{current_user.first_name}: #{@product.title}", status: :bad_request
      else
        invoice.save!
        Download.create(item: @product, user: current_user)
        render json: invoice
      end
    else
      invoice
    end
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

  def premium?
    Download.where(user: current_user).count >= 5
  end
end
