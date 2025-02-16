class AddCompanyToOrders < ActiveRecord::Migration[7.2]
  def up
    # Add the reference column as nullable first
    add_reference :orders, :company, null: true, foreign_key: true

    # Update existing records to use the company from their associated users
    execute <<-SQL
      UPDATE orders#{' '}
      SET company_id = users.company_id#{' '}
      FROM users#{' '}
      WHERE orders.user_id = users.id
    SQL

    # Now make it non-nullable
    change_column_null :orders, :company_id, false
  end

  def down
    remove_reference :orders, :company
  end
end
