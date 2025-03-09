class User < ApplicationRecord
  acts_as_tenant(:company)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :user_type, presence: true, inclusion: { in: %w[admin customer] }

  after_create_commit :create_cart_for_user

  def name
    "#{first_name} #{last_name}"
  end

  def admin?
    user_type == "admin"
  end

  def customer?
    user_type == "customer"
  end

  # Define which attributes can be used for Ransack searches in ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "first_name", "id", "last_name", "updated_at", "user_type"]
  end

  # Allow associations to be searchable
  def self.ransackable_associations(auth_object = nil)
    ["cart", "company"]
  end

  private

  def create_cart_for_user
    create_cart(company_id: company_id) unless cart.present?
  end
end
