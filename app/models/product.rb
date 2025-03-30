class Product < ApplicationRecord
  acts_as_tenant(:company)

  has_one_attached :image
  belongs_to :company
  has_many :carts_products, dependent: :destroy
  has_many :reviews, dependent: :destroy

  # Define which attributes can be used for Ransack searches in ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "price", "stock", "updated_at"]
  end

  # Allow associations to be searchable
  def self.ransackable_associations(auth_object = nil)
    ["company", "carts_products", "reviews"]
  end

  def average_rating
    reviews.average(:rating)
  end
end
