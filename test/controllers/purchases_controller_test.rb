require "test_helper_training"

class PurchasesControllerTest < TestHelperTraining
  test 'users can purchase products' do
    alice = create_user(first_name: 'Alice')
    bob = create_user(first_name: 'Bob')

    book_1 = create_book(title: 'Remote', isbn: '0804137501', purchase_price: 42, is_hot: false)
    book_2 = create_book(title: 'Rework', isbn: '0307463745', purchase_price: 42, is_hot: false)
    book_3 = create_book(title: "It Doesn't Have to Be Crazy at Work", isbn: '0062874780', purchase_price: 42, is_hot: false)

    post purchases_url, params: { user_id: alice.id, product_id: book_1.id }
    assert_equal 200, response.status, response.body
    post purchases_url, params: { user_id: alice.id, product_id: book_2.id }
    assert_equal 200, response.status, response.body
    post purchases_url, params: { user_id: bob.id, product_id: book_3.id }
    assert_equal 200, response.status, response.body

    get purchases_url, params: { user_id: alice.id }

    purchased_books = response.parsed_body
    assert_equal 2, purchased_books.size
    assert_equal 'Remote', purchased_books[0]['title']
    assert_equal 'Rework', purchased_books[1]['title']
  end

  test 'creates a download when purchasing a product' do
    user = create_user(first_name: 'Alice')
    book = create_book(title: 'Team Topologies', isbn: '9781942788829', purchase_price: 42, is_hot: false)

    # No downloads before purchase
    get downloads_url, params: { user_id: user.id }
    downloaded_books = response.parsed_body['books']
    assert_nil downloaded_books

    post purchases_url, params: { user_id: user.id, product_id: book.id }
    assert_equal 200, response.status, response.body

    # One download after purchase
    get downloads_url, params: { user_id: user.id }
    downloaded_books = response.parsed_body['books'] || []
    assert_equal 1, downloaded_books.count
    assert_equal 'Team Topologies', downloaded_books[0]['title']
  end

  test 'purchases contain a price and reference to the product purchased' do
    user = create_user(first_name: 'Alice')
    book = create_book(title: 'Extreme Ownership', isbn: '9783962670658', purchase_price: 12, is_hot: false)

    post purchases_url, params: { user_id: user.id, product_id: book.id }
    assert_equal 200, response.status, response.body

    get purchases_url, params: { user_id: user.id }
    purchased_book = response.parsed_body[0]
    assert_equal 'Extreme Ownership', purchased_book['title']
    assert_equal book.id, purchased_book['item_id']
    assert_equal 15, purchased_book['price']
  end

  [
    [Time.new(2022, 1, 3), 'Monday', 9.99],
    [Time.new(2022, 1, 4), 'Tuesday', 9.99],
    [Time.new(2022, 1, 5), 'Wednesday', 9.99],
    [Time.new(2022, 1, 6), 'Thursday', 9.99],
    [Time.new(2022, 1, 7), 'Friday', 9.99],
    [Time.new(2022, 1, 8), 'Saturday', 20],
    [Time.new(2022, 1, 9), 'Sunday', 20],
  ].each do |time, day, expected_price|
    test "prices hot books at 9.99 only on weekdays: #{day}" do
      user = create_user(first_name: 'Alice')
      book = create_book(title: 'The Software Craftsman', isbn: '0134052501', purchase_price: 16, is_hot: true)
      Timecop.travel(time)
      post purchases_url, params: { user_id: user.id, product_id: book.id }
      assert_price_equal expected_price, response.parsed_body['price']
    end
  end

  [
    [Time.new(2022, 1, 1) + 5.hours - 1.minute, 7.2, '04:59'],
    [Time.new(2022, 1, 1) + 5.hours + 1.minute, 12, '05:01'],
    [Time.new(2022, 1, 1) + 22.hours - 1.minute, 12, '21:59'],
    [Time.new(2022, 1, 1) + 22.hours + 1.minute, 7.2, '22:01'],
  ].each do |time, expected_price, hour|
    test "reduces video prices by -40% during the night: #{hour}" do
      user = create_user(first_name: 'Alice')
      video = create_video(title: 'From object oriented to functional domain modeling', duration: 150, quality: '4k')

      Timecop.travel time
      post purchases_url, params: { user_id: user.id, product_id: video.id }
      assert_price_equal expected_price, response.parsed_body['price']
    end
  end

  test 'bumps price of any book or video by +5% if the title contains "premium"' do
    user = create_user(first_name: 'Alice')

    standard_book = create_book(title: 'Accelerate', isbn: '9781942788355', purchase_price: 12, is_hot: false)
    post purchases_url, params: { user_id: user.id, product_id: standard_book.id }
    assert_price_equal 15, response.parsed_body['price']

    premium_book = create_book(title: 'The Mythical Man-Month premium', isbn: '9780132119160', purchase_price: 12, is_hot: false)
    post purchases_url, params: { user_id: user.id, product_id: premium_book.id }
    assert_price_equal 15.75, response.parsed_body['price']

    image = create_image(title: 'Title of Image', width: 800, height: 600, source: 'unknown', format: 'jpg')
    post purchases_url, params: { user_id: user.id, product_id: image.id }
    assert_price_equal 7, response.parsed_body['price']

    image = create_image(title: 'Premium title of Image', width: 800, height: 600, source: 'unknown', format: 'jpg')
    post purchases_url, params: { user_id: user.id, product_id: image.id }
    assert_price_equal 7, response.parsed_body['price']

    Timecop.travel Time.new(2022, 1, 1) + 22.hours - 1.minute
    video = create_video(title: 'A microservices-ready monolith', duration: 150, quality: '4k')
    post purchases_url, params: { user_id: user.id, product_id: video.id }
    assert_price_equal 12, response.parsed_body['price']

    video = create_video(title: 'Technical Debt Metaphor explained by Ward Cunningham *premium', duration: 150, quality: 'other')
    post purchases_url, params: { user_id: user.id, product_id: video.id }
    assert_price_equal 15.75, response.parsed_body['price']
  end

  test 'the title and price in the invoice does not change when product changes' do
    user = create_user(first_name: 'Alice')
    book = create_book(title: 'Drive', isbn: '9781101524275', purchase_price: 42, is_hot: false)

    post purchases_url, params: { user_id: user.id, product_id: book.id }
    assert_equal 200, response.status, response.body
    book.update!(title: 'Drive: The surprising truth about what motivates us')

    get purchases_url, params: { user_id: user.id }
    purchased_book = response.parsed_body[0]
    assert_equal 'Drive', purchased_book['title']
    assert_equal 52.5, purchased_book['price']
  end

  test "redirect to product list when product doesn't exist" do
    user = create_user(first_name: 'Alice')
    post purchases_url, params: { user_id: user.id, product_id: 123 }
    assert_redirected_to(products_path)
  end

  test "bad request when product was already bought" do
    user = create_user(first_name: 'Alice')
    book = create_book(title: 'Team Topologies', isbn: '9781942788829', purchase_price: 42, is_hot: false)

    post purchases_url, params: { user_id: user.id, product_id: book.id }
    assert_response :success

    post purchases_url, params: { user_id: user.id, product_id: book.id }
    assert_response :bad_request
    assert_equal "Product is already in the library of Alice: Team Topologies", response.body
  end

  test 'premium users get 10% discount on 4k videos' do
    user = create_premium_user(first_name: 'John')
    Timecop.travel Time.new(2022, 1, 1) + 6.hours
    video = create_video(title: "Technical coaching with the Samman method - Emily Bache", duration: 150, quality: '4k')

    post purchases_url, params: { user_id: user.id, product_id: video.id }
    assert_price_equal 10.8, response.parsed_body['price']
  end

  test 'premium users get 10% discount on images larger than 1920*1080' do
    user = create_premium_user(first_name: 'John')
    image = create_image(title: 'Image title', width: 2500, height: 1500, source: 'Getty', format: 'jpg')

    post purchases_url, params: { user_id: user.id, product_id: image.id }
    assert_price_equal 4.5, response.parsed_body['price']
  end

  test 'user must be authenticated to buy a product' do
    book = create_book(title: 'Team Topologies', isbn: '9781942788829', purchase_price: 42, is_hot: false)
    post purchases_url, params: { product_id: book.id }
    assert_response :unauthorized
    assert_equal "User is not authenticated", response.body
  end

  test 'user must be authenticated to list invoices' do
    get purchases_url
    assert_response :unauthorized
    assert_equal "User is not authenticated", response.body
  end
end
