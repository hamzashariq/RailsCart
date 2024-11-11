class Order < ApplicationRecord
  belongs_to :User
  has_many :product_snapshots
end
