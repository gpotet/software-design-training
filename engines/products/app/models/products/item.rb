module Products
  class Item < ApplicationRecord
    self.table_name = 'items'

    validates :title, presence: true
    validates :content, presence: true

    KINDS = %w(book image video)
    validates :kind, presence: true, inclusion: { in: KINDS }

    attr_accessor :price
  end
end
