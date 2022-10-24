# frozen_string_literal: true
module Marketing
  class Rating < ApplicationRecord
    belongs_to :item, class_name: 'Products::Item'
  end
end
