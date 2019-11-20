class Customer < ApplicationRecord
    has_many :sales_details
    has_many :orders, through: :sales_details
end
