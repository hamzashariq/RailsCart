class Cart < ApplicationRecord
  has_many :carts_products, dependent: :destroy
  belongs_to :user, optional: true

  def total_items
    carts_products.sum(:quantity)
  end

  def total_price
    carts_products.sum { |cart_product| cart_product.product.price * cart_product.quantity }
  end

  def empty!
    carts_products.each(&:destroy!)
  end
end
