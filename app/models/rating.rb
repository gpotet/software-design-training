# frozen_string_literal: true
class Rating < ApplicationRecord
  belongs_to :item, class_name: 'Products::Item'
end
