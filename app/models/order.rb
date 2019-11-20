class Order < ApplicationRecord
    has_many :sales_details
end
