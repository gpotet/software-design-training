# Iteration 3: pricing simulation

Some creators want to have a price simulation before adding their content to the store.
It's time to offer more transparency!

In this iteration, we will add an endpoint ([PriceSimulationsController#compute](../app/controllers/price_simulations_controller.rb)) to compute the price of an item, only from its given attributes.
Some attributes are optional such as `title` or `is_hot` as they have a clear default (`false`) on pricing.
Make sure to return good errors like defined in the tests ;)

Unskip tests from [iteration_3_test.rb](../test/controllers/iteration_3_test.rb) and fix what is needed.

## Cheatsheet

### Render json in controller

- `render json: value.to_json`
- `render json: { price: price }`
- `render json: { error: err }, status: :bad_request`

### Catching exceptions

All exceptions:

```ruby
begin
  compute_or_raise(params)
rescue => e
  raise e
end
```

Specific exception:

```ruby
begin
  compute_or_raise(params)
rescue ArgumentError => e
  raise e
end
```

Multiple exceptions:

```ruby
begin
  compute_or_raise(params)
rescue ArgumentError => e
  raise e
rescue TypeError => e
  raise e
rescue StandardError => e
  raise e
end
```

see [rollbar.com/guides/ruby/how-to-handle-exceptions-in-ruby](https://rollbar.com/guides/ruby/how-to-handle-exceptions-in-ruby)

### Create custom exception

Basic one:

```ruby
class MyError < StandardError
end

raise MyError
```

With custom attributes:

```ruby
class ErrorWithData < StandardError
  attr_reader :value
  def initialize(value: 'default')
    @value = value
    super("ErrorWithData(#{value})")
  end
end

raise ErrorWithData.new('value')
```
