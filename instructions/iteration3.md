# Iteration 3: pricing simulation

Some creators want to have a price simulation before adding their content to the store.
It's time to offer more transparency!

In this iteration, we will add an endpoint ([PriceSimulationsController#compute](../app/controllers/price_simulations_controller.rb)) to compute the price of an item, only from its given attributes.
Some attributes are optional such as `title` or `is_hot` as they have a clear default (`false`) on pricing.
Make sure to return good errors like defined in the tests ;)

Unskip tests from [iteration_3_test.rb](../test/controllers/iteration_3_test.rb) and fix what is needed.
