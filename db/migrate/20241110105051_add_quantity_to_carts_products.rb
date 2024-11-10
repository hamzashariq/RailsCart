class AddQuantityToCartsProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :carts_products, :quantity, :integer, null: false
  end
end
