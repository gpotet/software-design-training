- `Time.now.on_weekday?` checks if we are in weekday
- `Time.now.hour.between?(5, 21)` checks if hour is between 5 and 21

Read csv:

```ruby
path = Rails.root.join('app/assets/config/isbn_prices.csv')
return {} unless File.exist?(path)
prices = CSV.read(path, headers: true, header_converters: :symbol).index_by { |entry| entry[:isbn] }
price = prices['9781603095099']
```
