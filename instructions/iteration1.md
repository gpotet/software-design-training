# Iteration 1: add specific product details

## Context

We noticed that we miss some meaningful information to describe our products and sell them better.
Let's add some:

- **books**: `isbn` (string, e.g. '9781603095099'), `purchase_price` (float), `is_hot` (boolean)
- **images**: `width` (int), `height` (int), `source` ('unknown', 'Getty', 'NationalGeographic'), `format` ('jpg', 'png', 'raw')
- **videos**: `duration` (int in seconds), `quality` (4k, SD, FullHD)

We want to retrieve them from the [ProductsController#index](../app/controllers/products_controller.rb) endpoint.
And oh, `purchase_price`, `created_at` and `updated_at` fields should not be exposed anymore, as it's information we want to keep private ^^

## Instructions

- First, let's think about how you would model and store products with these details.
- Let us know when you've picked one, and we'll provide you with an implementation
- Now let's have a look at how it's implemented and if you would change parts of the design.

NB: tests in [iteration_1_test.rb](../test/controllers/iteration_1_test.rb) cover everything, you should be able to refactor safely.

## Cheatsheet (use your time for design, not Ruby/Rails implementation details)

### Update data model

You will (probably) need to change files in:

- [app/models/item.rb](../app/models/item.rb): keep it, delete it or change it and/or create new ones
- [db/migrate](../db/migrate): align database to models
- [app/controllers/products_controller.rb](../app/controllers/products_controller.rb): fetch items for the view
- [app/views/products/index.json.jbuilder](../app/views/products/index.json.jbuilder): display items in JSON API
- [test/test_helper_training.rb](../test/test_helper_training.rb): create models for tests

### Examples of Rails command to generate migrations (you don't need to launch them, just adapt as needed)

- `bin/rails generate migration CreateArticles name:string content:string`: create a table
- `bin/rails generate migration AddIsbnToBooks isbn:string`: add column
- `bin/rails generate migration RemoveContentFromItems content:string`: remove column
- `bin/rails generate migration AddArticleRefToComments article:references`: add relation
- `bin/rails generate migration AddReviewsToArticle reviews:references{polymorphic}`: add polymorphic relation
- `bin/rails generate migration MyMigration`: create an empty migration
- `bin/rails db:drop db:create db:migrate`: reset the database and run migrations

Types for a column: `string`, `text`, `integer`, `float`, `boolean`

Recreate your database: `bin/rails db:drop db:create db:migrate`

cf [guides.rubyonrails.org/active_record_migrations.html](https://guides.rubyonrails.org/active_record_migrations.html)
