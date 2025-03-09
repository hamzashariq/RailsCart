class Company < ApplicationRecord
  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: { case_sensitive: false }
  validates :subdomain, format: { with: /\A[a-z0-9]+(-[a-z0-9]+)*\z/, message: "can only contain lowercase letters, numbers, and hyphens" }
  validates :subdomain, length: { minimum: 2, maximum: 63 }

  has_many :users, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :carts, dependent: :destroy
  has_many :orders, dependent: :destroy

  accepts_nested_attributes_for :users

  before_validation :normalize_subdomain

  # Define which attributes can be used for Ransack searches in ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "subdomain", "updated_at"]
  end

  # Allow associations to be searchable
  def self.ransackable_associations(auth_object = nil)
    ["carts", "orders", "products", "users"]
  end

  private

  def normalize_subdomain
    self.subdomain = subdomain.to_s.downcase.strip
  end
end
