class User < ApplicationRecord
    has_many :product_invoices
    validates :first_name, presence: true
end
