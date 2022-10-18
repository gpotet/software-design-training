require "test_helper_training"

class Iteration1PricingTest < TestHelperTraining
  test 'hot book price is displayed' do
    skip 'unskip at iteration 1'

    book = create_book(title: 'The Software Craftsman', isbn: '0134052501', purchase_price: 16, is_hot: true)
    Timecop.travel(Time.new(2022, 1, 4)) # Tuesday
    get '/products'
    assert_price_equal 9.99, response.parsed_body['books'][0]['price']
    get "/products/#{book.id}"
    assert_price_equal 9.99, response.parsed_body['price']
  end

  test 'premium price is displayed' do
    skip 'unskip at iteration 1'

    Timecop.travel Time.new(2022, 1, 1) + 22.hours - 1.minute
    book = create_book(title: 'The Mythical Man-Month premium', isbn: '9780132119160', purchase_price: 12, is_hot: false)
    image = create_image(title: 'Premium title of Image', width: 800, height: 600, source: 'unknown', format: 'jpg')
    video = create_video(title: 'Technical Debt Metaphor explained by Ward Cunningham *premium', duration: 150, quality: '4k')

    get '/products'
    assert_price_equal 15.75, response.parsed_body['books'][0]['price']
    assert_price_equal 7, response.parsed_body['images'][0]['price']
    assert_price_equal 12.6, response.parsed_body['videos'][0]['price']

    get "/products/#{book.id}"
    assert_price_equal 15.75, response.parsed_body['price']

    get "/products/#{image.id}"
    assert_price_equal 7, response.parsed_body['price']

    get "/products/#{video.id}"
    assert_price_equal 12.6, response.parsed_body['price']
  end

  test "video price is displayed with 40% reduction during the night" do
    skip 'unskip at iteration 1'

    video = create_video(title: 'From object oriented to functional domain modeling', duration: 150, quality: '4k')

    Timecop.travel(Time.new(2022, 1, 1) + 1.hours) # 1:00 AM
    get '/products'
    assert_price_equal 7.2, response.parsed_body['videos'][0]['price']
    get "/products/#{video.id}"
    assert_price_equal 7.2, response.parsed_body['price']
  end

end
