class Download < ApplicationRecord
  belongs_to :user
  belongs_to :item, class_name: 'Products::Item'
end
