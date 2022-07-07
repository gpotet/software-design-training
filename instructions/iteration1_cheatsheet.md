# Update data model

You will probably need to change files in:
- [app/models/item.rb](../app/models/item.rb): adapt it and/or create new ones
- [db/migrate](../db/migrate): align database to models
- [app/controllers/products_controller.rb](../app/controllers/products_controller.rb): fetch items for the view
- [app/views/products/index.json.jbuilder](../app/views/products/index.json.jbuilder): display items in JSON API
- [test/test_helper_training.rb](../test/test_helper_training.rb): create models for tests

# Migrate your database

- `bin/rails generate migration CreateArticles name:string content:string`: create a table
- `bin/rails generate migration AddIsbnToBooks isbn:string`: add column
- `bin/rails generate migration RemoveContentFromItems content:string`: remove column
- `bin/rails generate migration MyMigration`: create an empty migration
- `bin/rails db:drop db:create db:migrate`: reset the database and run migrations

cf https://guides.rubyonrails.org/active_record_migrations.html
