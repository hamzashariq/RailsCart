class Cart < ApplicationRecord
  acts_as_tenant(:company)

  belongs_to :company
  belongs_to :user, optional: true
  has_many :carts_products, dependent: :destroy

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
