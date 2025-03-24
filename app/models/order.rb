class Order < ApplicationRecord
  acts_as_tenant(:company)

  belongs_to :company
  belongs_to :user
  has_one :delivery_information
  has_many :product_snapshots
  has_many :order_histories, dependent: :destroy

  accepts_nested_attributes_for :delivery_information

  enum delivery_status: {
    pending: 0,
    confirmed: 1,
    shipped: 2,
    delivered: 3,
    cancelled: 4
  }

  after_create :create_initial_history
  after_update :track_status_change, if: :saved_change_to_delivery_status?

  def total
    product_snapshots.sum(:price)
  end

  # Define which attributes can be used for Ransack searches in ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "delivery_status", "id", "updated_at", "user_id"]
  end

  # Allow associations to be searchable
  def self.ransackable_associations(auth_object = nil)
    ["company", "delivery_information", "product_snapshots", "user", "order_histories"]
  end

  private

  def create_initial_history
    order_histories.create!(
      note: "Order placed",
      status_to: delivery_status
    )
  end

  def track_status_change
    order_histories.create!(
      note: "Order status changed from #{delivery_status_previously_was} to #{delivery_status}",
      status_from: delivery_status_previously_was,
      status_to: delivery_status
    )
  end
end
