class AddCompanyToCarts < ActiveRecord::Migration[7.2]
  def up
    # Get the default company (should exist from previous migration)
    company = Company.find_by!(subdomain: 'default')

    # Add the reference column as nullable first
    add_reference :carts, :company, null: true, foreign_key: true

    # Update existing records
    Cart.update_all(company_id: company.id)

    # Now make it non-nullable
    change_column_null :carts, :company_id, false
  end

  def down
    remove_reference :carts, :company
  end
end
