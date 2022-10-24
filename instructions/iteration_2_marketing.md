# Marketing: newsletter

Our store is full of goods to sell, but still has too few sales.
We want to create a monthly newsletter recommending best books of the month to all our users, with their corresponding average ratings.
For this we will use `Marketing::NewsletterMailer#monthly`

But we also started to split properly our application in isolated components with clear boundaries, and we'll need to do some refactoring along the way:
* Our products repository is a core capability that we want to isolate properly from anything related to marketing. In particular, this means:
  * We don't expect the **Products** engine to depend on marketing so we can't add anything related to marketing in the `Item` model.
  * The **Products** engine exposes `items` only through its public API.
    * In particular, this API doesn't expose any ActiveRecord object
  * We can't have any foreign key between items and marketing related data as we plan to isolate DB schemas. The current version includes one which needs to be removed.


* Unskip tests from `iteration_2_marketing_test.rb` and fix what is needed.
* The newsletter content is already implemented, you just need to connect pieces. 

Cheatsheet:

```ruby 
def formatted_price(price)
  '%.2f' % price
end

def average_rating(ratings)
  "#{ratings.sum / ratings.count.to_f}/5"
end
```

Bonus if you have time: 
  * What are all the components and bounded contexts in our application? 
  * What are the dependencies between these components? 
  * How can we make sure we don't have any circular dependency?
  * Let's create these components and isolate them properly.

