class Cart < ApplicationRecord
  has_many :carts_products, dependent: :destroy
  belongs_to :user, optional: true

  def total_items
    carts_products.sum(:quantity)
  end
end
