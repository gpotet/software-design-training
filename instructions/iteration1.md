# Iteration 1: add specific product details

## Context 

We noticed that we miss some meaningful information to describe our products and sell them.
Let's add them:

- books: isbn (string, e.g. '9781603095099'), purchase_price (float), is_hot (boolean)
- images: width (int), height (int), source ('unknown', 'Getty', 'NationalGeographic'), format ('jpg', 'png', 'raw')
- videos: duration (int in seconds), quality (4k, SD, FullHD)

We want to retrieve them from the `products_controller#index` endpoint.
And oh, `created_at` and `updated_at` fields should not be exposed anymore, and of course, not the `purchase_price` also ^^.

## Instructions

* First, let's think about how you would model and store products with these details.
* Let us know when you've picked one and we'll provide you with an implementation
* Now let's have a look at how it's implemented and if you would change parts of the design.

NB: tests in `iteration_1_test.rb` cover everything, you should be able to refactor safely.
