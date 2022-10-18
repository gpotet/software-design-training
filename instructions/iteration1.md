# Iteration 1: add specific product details

## Context 

When a customer buys a product, we apply some price variations (see pricing rules below)
Unfortunately, these variations aren't displayed in the product list, which makes it hard to understand for our customers before they actually buy a product.

### Pricing rules

- books:
    - compute price with +25% from `purchase_price` instead of the environment variable
    - if book is present in `app/assets/config/isbn_prices.csv`, get it from there instead
- images
    - if source is 'NationalGeographic', the price is 0.02/9600px
    - if source is 'Getty'
        - price is 1 when same or fewer pixels than 1280x720
        - price is 3 when same or fewer pixels than 1920x1080
        - price is 5 otherwise
        - if format is 'raw', price is 10 whatever the size
    - otherwise, price is 7
- videos
    - '4k' videos are priced at 0.08/second
    - 'FullHD' videos are priced at 3 per started minute
    - 'SD' videos are priced at 1 per started minute
    - time over 10 minutes is not accounted for 'SD' videos
    - for other formats, price is 15

Price variations:
- if the book is_hot, its price should be 9.99 during weekdays
- video price is reduced by 40% during the night (22 PM - 5 AM)
- books and videos only: if the title of the item contains "premium" with any capitalization, increase the price by 5%


### Product details

Products have different details depending on item kind:

- books: isbn (string, e.g. '9781603095099'), purchase_price (float), is_hot (boolean)
- images: width (int), height (int), source ('unknown', 'Getty', 'NationalGeographic'), format ('jpg', 'png', 'raw')
- videos: duration (int in seconds), quality (4k, SD, FullHD)


## Instructions

We want to apply price variations also in the products list and product details endpoints.
* Unfortunately, the code is currently hard to change, let's refactor it first.
  * Existing tests cover all existing cases, you can refactor safely
* Once you're done with refactoring, let's develop our new feature
  * Tests in `iteration_1_test.rb` cover new cases, you just need to un-skip them
