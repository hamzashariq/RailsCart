class OrderHistory < ApplicationRecord
  belongs_to :order

  validates :note, presence: true
end
