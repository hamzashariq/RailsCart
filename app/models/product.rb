class Product < ApplicationRecord
  acts_as_tenant(:company)

  belongs_to :company
  has_many :carts_products, dependent: :destroy
end
