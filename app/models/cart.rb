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

  # Define which attributes can be used for Ransack searches in ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "updated_at", "user_id"]
  end

  # Allow associations to be searchable
  def self.ransackable_associations(auth_object = nil)
    ["carts_products", "company", "user"]
  end
end
