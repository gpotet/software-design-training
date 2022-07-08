require "test_helper"

class TestHelperTraining < ActionDispatch::IntegrationTest
  def create_book(title:, content: 'content', isbn: '', purchase_price: 0.to_f, is_hot: false, created_at: nil)
    Item.create!(kind: 'book', title: title, content: content, created_at: created_at)
  end

  def create_image(title:, content: 'content', width: 0, height: 0, source: '', format: '', created_at: nil)
    Item.create!(kind: 'image', title: title, content: content, created_at: created_at)
  end

  def create_video(title:, content: 'content', duration: 0, quality: '', created_at: nil)
    Item.create!(kind: 'video', title: title, content: content, created_at: created_at)
  end

  def get_product_price(product)
    get '/products'
    assert_equal 200, response.status, response.body
    products_by_kind = response.parsed_body
    product_result = products_by_kind[product.kind.pluralize].find { |p| p['id'] == product.id}
    product_result['price'].to_f
  end

  def assert_price_equal(expected, actual)
    assert_in_delta expected, actual, 0.01
  end
end
