class AddContactPageContentToCompanies < ActiveRecord::Migration[7.2]
  def change
    add_column :companies, :contact_page_content, :text
  end
end
