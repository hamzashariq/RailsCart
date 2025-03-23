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

  has_many_attached :carousel_images

  # Validate max 5 images
  validate :carousel_images_limit

  # Define which attributes can be used for Ransack searches in ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "subdomain", "updated_at"]
  end

  # Allow associations to be searchable
  def self.ransackable_associations(auth_object = nil)
    ["users", "products", "orders", "carts"]
  end

  private

  def normalize_subdomain
    self.subdomain = subdomain.to_s.downcase.strip
  end

  def carousel_images_limit
    return unless carousel_images.attached?
    if carousel_images.count > 5
      errors.add(:carousel_images, "You can upload maximum 5 images")
    end
  end
end
