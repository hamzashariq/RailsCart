class Order < ApplicationRecord
  belongs_to :user
  has_one :delivery_information
  has_many :product_snapshots

  accepts_nested_attributes_for :delivery_information
end
