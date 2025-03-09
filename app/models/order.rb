class Order < ApplicationRecord
  acts_as_tenant(:company)

  belongs_to :company
  belongs_to :user
  has_one :delivery_information
  has_many :product_snapshots

  accepts_nested_attributes_for :delivery_information

  def total
    product_snapshots.sum(:price)
  end

  # Define which attributes can be used for Ransack searches in ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "delivery_status", "id", "updated_at", "user_id"]
  end

  # Allow associations to be searchable
  def self.ransackable_associations(auth_object = nil)
    ["company", "delivery_information", "product_snapshots", "user"]
  end
end
