# frozen_string_literal: true
class ProductInvoice < ApplicationRecord
  belongs_to :user
  belongs_to :item

  before_create :apply_price_variation

  def apply_price_variation
    if item.kind == 'book' && item.is_hot && Time.now.on_weekday?
      self.price = 9.99
    end
    if item.kind == 'video'
      self.price = Time.now.hour.between?(5, 21) ? price : price * 0.6
    end

    if item.kind == 'book' || item.kind == 'video'
      self.price = item.title.downcase.include?('premium') ? price * 1.05 : price
    end
  end
end
