# My Media Store

This repo is for the Doctolib software design training.

We are managing an online shop for digital goods: books, images and videos.
The goal of the training will be to extend it with a few more features.
The challenge will be to do it in the most maintainable way to support future evolutions.

In order to facilitate the code and focus more on architecture decisions than HTTP API design, some tests are provided for each iteration to clarify the API.
We focus on backend code, so we only develop a REST API, which is used with tests to validate its behavior.

## Getting started

- clone this repo
- run `bundle install`
- launch `bundle exec rails test` and check it works (with some skips ^^)
- create your own branch: `impl-<your name>`
- make a commit at each end of iteration

Tips:

- if you want/need to change models, you can update the migrations and reset the db, it will be quicker/easier ;) (`bundle exec rails db:drop db:create db:migrate`)

## Initial state

* `ProductsController` allows to list all products by kind (`ProductsController#index`), and also to display details for a given product (`ProductsController#show`).
* Authenticated users can buy a product using `PurchasesController#create`, which is added to their library so they can download it anytime using `DownloadsController#index`.
* Authenticated users can also consult their past invoices list using `PurchasesController#index`.

All existing behavior is covered with tests.

Now let's start and open [instructions/iteration_1_pricing.md](instructions/iteration_1_pricing.md) for the first iteration.
We provide minimal tests for each iteration to guide you (see `iteration_x_test.rb`), but you can write more if you want/need.

**Please do not look at instructions/tests ahead of time, that would spoil you and ruin the training ^^**
