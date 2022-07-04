# Iteration 4: external image service & newsletter

## External image service

We now want to support another strage kind for our images. Images can now be uploaded and fetched from an
external service by using the class `ImageExternalService`. More specifically, this external service stores
the following attributes of our images: `width`, `height`, `source` and `format`.

Those attributes should no longer be stored in our database. Our database should only store the external ID provided
by the external service to identify the image data.

All this happens only if `ENV['IMAGES_FROM_EXTERNAL_SERVICE'] = 'true'`. Otherwise, we keep the same database
storage as the previous iterations.

## Newsletter

Our store is full of goods to sell, but still has too few sales.
We want to create a monthly newsletter (`newsletter_job`) recommending best books of the month to all our users.

Unskip tests from `iteration_4_test.rb` and fix what is needed.
