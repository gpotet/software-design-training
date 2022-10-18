require "test_helper_training"

class DownloadsControllerTest < TestHelperTraining
  test 'a bought item appears in the library' do
    user = User.create!(first_name: 'Bob')
    book_to_download_1 = create_book(title: 'A Philosophy of Software Design', content: 'Book1 content')
    book_to_download_2 = create_book(title: 'Head First Design Patterns', content: 'Book2 content')
    book_not_to_download = create_book(title: 'The Mikado Method', content: 'Book3 content')

    post purchases_url, params: { user_id: user.id, product_id: book_to_download_1.id }
    post purchases_url, params: { user_id: user.id, product_id: book_to_download_2.id }

    get downloads_url, params: { user_id: user.id }

    downloaded_books = response.parsed_body['books']
    assert_equal 2, downloaded_books.count
    assert_equal 'A Philosophy of Software Design', downloaded_books[0]['title']
    assert_equal 'Book1 content', downloaded_books[0]['content']
    assert_equal 'Head First Design Patterns', downloaded_books[1]['title']
    assert_equal 'Book2 content', downloaded_books[1]['content']
  end

  test 'a user can download an item only once' do
    user = User.create!(first_name: 'Bob')
    book_to_download = create_book(title: 'Radical Candor', content: 'Book content')

    post purchases_url, params: { user_id: user.id, product_id: book_to_download.id }
    assert_response :success

    post purchases_url, params: { user_id: user.id, product_id: book_to_download.id }
    assert_response :bad_request
  end

  test 'user must be authenticated' do
    get downloads_url
    assert_response :unauthorized
    assert_equal "User is not authenticated", response.body
  end
end
