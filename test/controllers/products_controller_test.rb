require "test_helper_training"

class ProductsControllerTest < TestHelperTraining
  test 'get all products' do
    create_book(title: 'Domain-Driven Design', content: 'Book1 content')
    create_book(title: 'Turn the Ship Around', content: 'Book2 content')
    create_video(title: 'What is functional programming?', content: 'Video content')

    get '/products'
    products_by_kind = response.parsed_body

    books = products_by_kind['books']
    assert_equal 2, books.count
    assert_equal 'book', books[0]['kind']
    assert_equal 'Domain-Driven Design', books[0]['title']
    assert_equal 'Book1 content', books[0]['content']
    assert_equal 'book', books[1]['kind']
    assert_equal 'Turn the Ship Around', books[1]['title']
    assert_equal 'Book2 content', books[1]['content']

    videos = products_by_kind['videos']
    assert_equal 'video', videos[0]['kind']
    assert_equal 'What is functional programming?', videos[0]['title']
    assert_equal 'Video content', videos[0]['content']
  end

  test 'get the products of a month' do
    create_book(title: 'The Lean Startup', content: 'Book content', created_at: '2019-01-01')
    create_video(title: 'TDD as in Type-Driven Development', content: 'Video content', created_at: '2019-02-01')

    get '/products?month=february'
    products_by_kind = response.parsed_body

    assert_equal ['videos'], products_by_kind.keys
    videos = products_by_kind['videos']
    assert_equal 'video', videos[0]['kind']
    assert_equal 'TDD as in Type-Driven Development', videos[0]['title']
    assert_equal 'Video content', videos[0]['content']
  end

  test 'products have additional details by kind' do
    create_book(title: 'Clean Code', isbn: '9780132350884', purchase_price: 12, is_hot: false)
    create_image(title: 'Manifesto for Agile Software Development', width: 800, height: 600, source: 'Getty', format: 'jpg')
    create_video(title: 'Making Impossible States Impossible', duration: 120, quality: 'FullHD')

    get '/products'
    products_by_kind = response.parsed_body

    book = products_by_kind['books'][0]
    assert_equal 'book', book['kind']
    assert_equal 'Clean Code', book['title']
    assert_equal '9780132350884', book['isbn']
    assert_nil book['purchase_price']
    assert_equal false, book['is_hot']
    assert_nil book['created_at']

    image = products_by_kind['images'][0]
    assert_equal 'image', image['kind']
    assert_equal 'Manifesto for Agile Software Development', image['title']
    assert_equal 800, image['width']
    assert_equal 600, image['height']
    assert_equal 'Getty', image['source']
    assert_equal 'jpg', image['format']
    assert_nil image['created_at']

    video = products_by_kind['videos'][0]
    assert_equal 'video', video['kind']
    assert_equal 'Making Impossible States Impossible', video['title']
    assert_equal 120, video['duration']
    assert_equal 'FullHD', video['quality']
    assert_nil video['created_at']
  end

  test 'product show' do
    book = create_book(title: '99 Bottles of OOP, A practical guide to Object-Oriented Design', purchase_price: 36)
    get "/products/#{book.id}"
    assert_equal '99 Bottles of OOP, A practical guide to Object-Oriented Design', response.parsed_body['title']
    assert_equal 45, response.parsed_body['price']
    assert_not response.parsed_body['in_library']
  end

  test 'get product displays information about product already in library' do
    user = create_user(first_name: 'Alice')
    book = create_book(title: 'Domain-Driven Design: Tackling Complexity in the Heart of Software')
    post purchases_url, params: { user_id: user.id, product_id: book.id }

    get "/products/#{book.id}?user_id=#{user.id}"
    assert_equal 'Domain-Driven Design: Tackling Complexity in the Heart of Software', response.parsed_body['title']
    assert response.parsed_body['in_library']
  end

end
