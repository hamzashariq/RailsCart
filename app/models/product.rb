class Product < ApplicationRecord
  has_many :carts_products, dependent: :destroy
end
