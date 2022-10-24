# Bonus: External image service

We now want to support another storage kind for our images. Images can now be uploaded and fetched from an
external service by using the class `ImageExternalService`.
We also want to keep our usual database storage, and use the external service only when the environment variable
`ENV['IMAGES_FROM_EXTERNAL_SERVICE'] = 'true'`.

Unskip tests from `bonus_external_image_service_test.rb` and fix what is needed.
