class Order < ApplicationRecord
  acts_as_tenant(:company)

  belongs_to :company
  belongs_to :user
  has_one :delivery_information
  has_many :product_snapshots

  accepts_nested_attributes_for :delivery_information
end
