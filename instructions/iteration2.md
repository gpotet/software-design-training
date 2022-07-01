# Iteration 2: compute price

## Context
Now we want to make money!
Product price is displayed in the products list, using the pricing rules listed below.

Pricing rules:
- books:
  - compute price with +25% from `purchase_price` instead of the environment variable
  - if the book is_hot, its price should be 9.99 during weekdays
  - if book is present in `app/assets/config/isbn_prices.csv`, get it from there instead
- images
  - if source is 'NationalGeographic', the price is 0.02/9600px
  - if source is 'Getty'
    - price is 1 when same or fewer pixels than 1280x720
    - price is 3 when same or fewer pixels than 1920x1080
    - price is 5 otherwise
    - expect if format is 'raw', price is 10 whatever the size
  - otherwise, price is 7
- videos
  - '4k' videos are priced at 0.08/second
  - 'FullHD' videos are priced at 3 per started minute
  - 'SD' videos are priced at 1 per started minute
  - time over 10 minutes is not accounted for 'SD' videos
  - for other formats, price is 15
  - video price is reduced by 40% during the night (22 PM - 5 AM)
- books and videos only: if the title of the item contains "premium" with any capitalization, increase the price by 5%

## Instructions

Price calculation was already developed in `ProductsController#price`, but we feel that it's hard to add new rules.
All rules are covered by tests defined in `iteration_2_test.rb`, so we'll be able to refactor safely.

Let's refactor our pricing system and improve its design!