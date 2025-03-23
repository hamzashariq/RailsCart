class ChangeDeliveryStatusToInteger < ActiveRecord::Migration[7.2]
  def up
    # First, rename the existing column to temporary name
    rename_column :orders, :delivery_status, :delivery_status_old

    # Add the new integer column
    add_column :orders, :delivery_status, :integer, default: 0

    # Migrate the data
    Order.reset_column_information
    Order.find_each do |order|
      status = case order.delivery_status_old&.downcase
      when 'pending' then 0
      when 'confirmed' then 1
      when 'shipped' then 2
      when 'delivered' then 3
      when 'cancelled' then 4
      else 0 # Default to pending if status is unknown
      end
      order.update_column(:delivery_status, status)
    end

    # Remove the old column
    remove_column :orders, :delivery_status_old
  end

  def down
    change_column :orders, :delivery_status, :string
  end
end
