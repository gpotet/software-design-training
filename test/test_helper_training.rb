require "test_helper"

class TestHelperTraining < ActionDispatch::IntegrationTest
  teardown do
    Timecop.return
  end
  def create_book(title:, content: 'content', isbn: nil, purchase_price: nil, is_hot: nil, created_at: nil)
    Book.create!(kind: 'book', title: title, content: content, created_at: created_at, isbn: isbn, purchase_price: purchase_price, is_hot: is_hot)
  end

  def create_image(title:, content: 'content', width: nil, height: nil, source: nil, format: nil, created_at: nil)
    Image.create!(kind: 'image', title: title, content: content, created_at: created_at, width: width, height: height, source: source, format: format)
  end

  def create_video(title:, content: 'content', duration: nil, quality: nil, created_at: nil)
    Video.create!(kind: 'video', title: title, content: content, created_at: created_at, duration: duration, quality: quality)
  end

  def create_user(first_name:)
    User.create!(first_name: first_name)
  end

  def create_premium_user(first_name:)
    user = create_user(first_name: first_name)
    5.times do |i|
      book = create_book(title: "Book #{i}")
      post purchases_url, params: { user_id: user.id, product_id: book.id }
      assert_response :success
    end
    user
  end

  def assert_price_equal(expected, actual)
    assert_in_delta expected, actual, 0.01
  end
end
