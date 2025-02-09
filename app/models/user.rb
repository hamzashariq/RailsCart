class User < ApplicationRecord
  acts_as_tenant(:company)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company
  has_one :cart, dependent: :destroy

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }

  after_create :create_cart_for_user

  def name
    "#{first_name} #{last_name}"
  end

  private

  def create_cart_for_user
    # Create a cart for the user, company_id will be automatically set by acts_as_tenant
    create_cart unless cart.present?
  end
end
