# Bonus: pricing rules

The code of our current pricing system (`Purchaser#compute_price`) is a bit complex, which makes it hard to understand and to change.
We would like to be able to easily:
* know all rules applied to a given type of product
* know when a given rule is being applied (e.g when do we apply a discount for premium customers?)
* limit duplication
* add new rules without changing the existing code.

Let's refactor the code!

Once you're done, let's add some new pricing rules:
* now any new customer (someone who never bought any product) benefits a 25% discount on top of all other pricing rules to any product except 4k videos or images with resolution greater than 1280 x 720.
* we have a new type of product (Video game), for which the following rules apply:
  * They have a quality attribute (4k, FullHD, SD) just as videos
  * 4k games cost 69.90, FullHD cost 59.90, SD cost 29.90 
  * Premium customers benefit from 10% discount on 4k games 
  * No other existing rule should apply

**This time we don't have any existing test, let's use TDD to cover these rules!**

Was it easy to add these rules without any duplication?
Did you introduce any specific design pattern? 