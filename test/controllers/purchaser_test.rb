require "test_helper_training"
require "csv"

class PurchaserTest < ActionDispatch::IntegrationTest
  include TestHelperTraining

  test 'prices books at +25% margin' do
    book1 = create_book(title: 'Practical Object‑Oriented Design in Ruby', isbn: '9780132930871', purchase_price: 12, is_hot: false)
    assert_price_equal 15, get_product_price(book1)

    book2 = create_book(title: 'Clean Architecture', isbn: '9780134494326', purchase_price: 16, is_hot: false)
    assert_price_equal 20, get_product_price(book2)
  end

  test 'checks the ISBN list to price books' do
    begin
      CSV.open(Rails.root.join('app/assets/config/isbn_prices.csv'), 'wb') do |csv|
        csv << ['ISBN', 'price']
        csv << ['1449373321', '14.99']
        csv << ['0131177052', '19.99']
        csv << ['1736049119', '23.99']
      end

      book = create_book(title: 'Working Effectively with Legacy Code', isbn: '1449373321', purchase_price: 12, is_hot: false)
      assert_price_equal 14.99, get_product_price(book)

      book = create_book(title: 'Working Effectively with Legacy Code - 2nd edition', isbn: 'unknown', purchase_price: 12, is_hot: false)
      assert_price_equal 15, get_product_price(book)

      book = create_book(title: 'Working Effectively with Legacy Code - 3rd edition', isbn: '0131177052', purchase_price: 12, is_hot: false)
      assert_price_equal 19.99, get_product_price(book)
    ensure
      File.delete(Rails.root.join('app/assets/config/isbn_prices.csv'))
    end
  end

  test 'prices images from NationalGeographic .02/9600px' do
    image = create_image(title: 'Manifesto for Software Craftsmanship', width: 800, height: 600, source: 'NationalGeographic', format: 'jpg')
    assert_price_equal 1, get_product_price(image)
  end

  test 'prices images from Getty at 1 when below 1280x720' do
    image = create_image(title: 'Title of Image', width: 1280, height: 720, source: 'Getty', format: 'jpg')
    assert_price_equal 1, get_product_price(image)
  end

  test 'prices images from Getty at 3 when below 1920x1080' do
    image1 = create_image(title: 'Title of Image1', width: 1281, height: 720, source: 'Getty', format: 'jpg')
    assert_price_equal 3, get_product_price(image1)

    image2 = create_image(title: 'Title of Image2', width: 1920, height: 1080, source: 'Getty', format: 'jpg')
    assert_price_equal 3, get_product_price(image2)
  end

  test 'prices images from Getty at 5 when above 1920x1080' do
    image = create_image(title: 'Title of Image', width: 1921, height: 1080, source: 'Getty', format: 'jpg')
    assert_price_equal 5, get_product_price(image)
  end

  test 'prices images from Getty in raw format at 10' do
    image1 = create_image(title: 'Title of Image1', width: 800, height: 600, source: 'Getty', format: 'raw')
    image2 = create_image(title: 'Title of Image2', width: 1920, height: 1080, source: 'Getty', format: 'raw')
    image3 = create_image(title: 'Title of Image3', width: 1921, height: 1080, source: 'Getty', format: 'raw')

    assert_price_equal 10, get_product_price(image1)
    assert_price_equal 10, get_product_price(image2)
    assert_price_equal 10, get_product_price(image3)
  end

  test 'prices other images at 7' do
    image = create_image(title: 'Title of Image', width: 800, height: 600, source: 'unknown', format: 'jpg')
    assert_price_equal 7, get_product_price(image)
  end

  test 'prices 4k videos at 0.08/second' do
    Timecop.travel Time.new(2022, 1, 1) + 6.hours
    video = create_video(title: "Treat Your Code as a Crime Scene - Adam Tornhill", duration: 150, quality: '4k')
    assert_price_equal 12, get_product_price(video)
  end

  test 'prices FullHD videos at 3 per started minute' do
    Timecop.travel Time.new(2022, 1, 1) + 6.hours
    video60 = create_video(title: 'Tail Call Optimization: The Musical', duration: 59, quality: 'FullHD')
    assert_price_equal 3, get_product_price(video60)
    video61 = create_video(title: 'Video games: The quest for smart dumbness', duration: 60, quality: 'FullHD')
    assert_price_equal 6, get_product_price(video61)
  end

  test 'prices SD videos at 1 per started minute' do
    Timecop.travel Time.new(2022, 1, 1) + 6.hours
    video60 = create_video(title: 'Introduction to Property-Based Testing', duration: 59, quality: 'SD')
    assert_price_equal 1, get_product_price(video60)
    video61 = create_video(title: 'CQRS, Fonctionnal programming, Event Sourcing & Domain Driven Design', duration: 60, quality: 'SD')
    assert_price_equal 2, get_product_price(video61)
  end

  test 'prices SD videos longer than 10 minutes at 10' do
    Timecop.travel Time.new(2022, 1, 1) + 6.hours
    video = create_video(title: 'Sunny Tech: Craft Forever', duration: 12 * 60, quality: 'SD')
    assert_price_equal 10, get_product_price(video)
  end

  def get_product_price(product)
    get "/products/#{product.id}"
    assert_response :success
    response.parsed_body['price'].to_f
  end
end
