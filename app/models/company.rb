class Company < ApplicationRecord
  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: { case_sensitive: false }
  validates :subdomain, format: { with: /\A[a-z0-9]+(-[a-z0-9]+)*\z/, message: "can only contain lowercase letters, numbers, and hyphens" }
  validates :subdomain, length: { minimum: 2, maximum: 63 }

  has_many :users, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :carts, dependent: :destroy
  has_many :orders, dependent: :destroy

  before_validation :normalize_subdomain

  private

  def normalize_subdomain
    self.subdomain = subdomain.to_s.downcase.strip
  end
end
