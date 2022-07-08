# Update data model

You will probably need to change files in:
- [app/models/item.rb](../app/models/item.rb): keep it, delete it or change it and/or create new ones
- [db/migrate](../db/migrate): align database to models
- [app/controllers/products_controller.rb](../app/controllers/products_controller.rb): fetch items for the view
- [app/views/products/index.json.jbuilder](../app/views/products/index.json.jbuilder): display items in JSON API
- [test/test_helper_training.rb](../test/test_helper_training.rb): create models for tests

# Examples of Rails command to generate migrations (you don't need to launch these examples, just adapt they as needed)

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
