class AddUserTypeToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :user_type, :string, default: 'customer', null: false
  end
end
