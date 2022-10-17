# frozen_string_literal: true
class ProductInvoice < ApplicationRecord
  belongs_to :user
  belongs_to :item
end
