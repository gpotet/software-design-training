# frozen_string_literal: true
module Marketing
  class NewsletterMailer < ApplicationMailer
    layout false

    def monthly(from:, to:)
      @books = []
      @images = []
      @videos = []
      mail to: 'user@example.com',
           subject: 'My Media Store - Discover our last available products',
           from: 'noreply@mymediastore.com'
    end

    def formatted_price(price)
      '%.2f' % price
    end

    def average_rating(ratings)
      "#{ratings.sum / ratings.count.to_f}/5"
    end
  end
end
