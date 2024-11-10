class Cart < ApplicationRecord
  has_many :carts_products, dependent: :destroy
  belongs_to :user, optional: true
end
