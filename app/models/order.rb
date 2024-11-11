class Order < ApplicationRecord
  belongs_to :User
  has_one :delivery_information
  has_many :product_snapshots
end
