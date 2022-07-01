# Iteration 4: external image service & newsletter

## External image service

We now want to support another strage kind for our images. Images can now be uploaded and fetched from an
external service by using the class `ImageExternalService`.
We also want to keep our usual database storage, and use the external service only when the environment variable
`ENV['IMAGES_FROM_EXTERNAL_SERVICE'] = 'true'`.

## Newsletter

Our store is full of goods to sell, but still has too few sales.
We want to create a monthly newsletter (`newsletter_job`) recommending best books of the month to all our users.

Unskip tests from `iteration_4_test.rb` and fix what is needed.
