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
  end
end
