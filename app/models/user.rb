class User < ApplicationRecord
  acts_as_tenant(:company)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company
  has_one :cart, dependent: :destroy

  after_create :create_cart_for_user

  private

  def create_cart_for_user
    # Create a cart for the user, company_id will be automatically set by acts_as_tenant
    create_cart unless cart.present?
  end
end
