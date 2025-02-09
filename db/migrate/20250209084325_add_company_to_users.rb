class AddCompanyToUsers < ActiveRecord::Migration[7.2]
  def up
    # Get the default company (should exist from previous migrations)
    company = Company.find_by!(subdomain: 'default')

    # Add the reference column as nullable first
    add_reference :users, :company, null: true, foreign_key: true

    # Update existing records
    User.update_all(company_id: company.id)

    # Now make it non-nullable
    change_column_null :users, :company_id, false
  end

  def down
    remove_reference :users, :company
  end
end
