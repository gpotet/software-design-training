require "test_helper_training"

class BonusExternalImageServiceTest < ActionDispatch::IntegrationTest
  include TestHelperTraining

  test 'gets an image with its details from an external service' do
    skip 'unskip when starting to work on "Bonus: External image service"'
    begin
      ENV['IMAGES_FROM_EXTERNAL_SERVICE'] = 'true'
      IMAGE_EXTERNAL_ID = 42
      ImageExternalService.expects(:upload_image_details).with(width: 800, height: 600, source: 'Getty', format: 'jpg').returns(IMAGE_EXTERNAL_ID)
      ImageExternalService.expects(:get_image_details).with(IMAGE_EXTERNAL_ID).returns({width: 800, height: 600, source: 'Getty', format: 'jpg'})

      image = create_image(title: 'Item 2', width: 800, height: 600, source: 'Getty', format: 'jpg')

      get products_url

      products_by_kind = response.parsed_body
      image = products_by_kind['images'][0]
      assert_equal 'Item 2', image['title']
      assert_equal 'image', image['kind']
      assert_equal 800, image['width']
    ensure
      ENV.delete('IMAGES_FROM_EXTERNAL_SERVICE')
    end
  end
end
