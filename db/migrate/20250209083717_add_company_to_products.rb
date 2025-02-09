class AddCompanyToProducts < ActiveRecord::Migration[7.2]
  def up
    # Create a default company if none exists
    company = Company.create_with(
      name: 'Default Company',
      subdomain: 'default'
    ).find_or_create_by!(subdomain: 'default')

    # Add the reference column as nullable first
    add_reference :products, :company, null: true, foreign_key: true

    # Update existing records
    Product.update_all(company_id: company.id)

    # Now make it non-nullable
    change_column_null :products, :company_id, false
  end

  def down
    remove_reference :products, :company
  end
end
