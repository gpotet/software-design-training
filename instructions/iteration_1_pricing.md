# Iteration 1: pricing rules & purchase

## Context 

When a customer buys a product, we apply some price variations (see pricing rules below)
Unfortunately, these variations aren't displayed in the product list, which makes it hard to understand for our customers before they actually buy a product.

### Pricing rules

- books:
    - compute price with 25% margin added to the `purchase_price`. 
      - `BOOK_PURCHASE_PRICE` environment variable is used when no `purchase_price` is provided. 
    - if the book is present in `app/assets/config/isbn_prices.csv`, get it from there instead.
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

Premium customers also benefit from exclusive discounts:
    - A customer is considered as premium as soon as he bought 5 products.
    - They benefit from 10% discount on high quality content: 4k videos or images larger than 1920x1080.

Price variations:
- if the book is_hot, its price should be 9.99 during weekdays (overrides all other pricing rules)
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
  * Step 1: Products and purchases endpoints seem very coupled regarding pricing, let's separate them properly.
  * Step 2: Let's apply [Avoid defining domain logic in Controllers](https://doctolib.atlassian.net/wiki/spaces/PTA/pages/1185906950/Avoid+defining+domain+logic+in+Rails+Controllers) guideline.
  * Step 3: Let's apply [Avoid using ActiveRecord API outside of ActiveRecord models](https://doctolib.atlassian.net/wiki/spaces/PTA/pages/1186496627/ADOPT+Avoid+using+ActiveRecord+API+outside+of+ActiveRecord+models)
    * And also [Consider using classes encapsulating ActiveRecord queries](https://doctolib.atlassian.net/wiki/spaces/PTA/pages/1186627655/ASSESS+Consider+using+classes+encapsulating+ActiveRecord+queries) if you see opportunities.
* Once you're done with refactoring, let's develop our new feature
  * Tests in `iteration_1_pricing_test.rb.rb` covers new cases, you just need to un-skip them
