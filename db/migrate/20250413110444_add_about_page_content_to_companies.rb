class AddAboutPageContentToCompanies < ActiveRecord::Migration[7.2]
  def change
    add_column :companies, :about_page_content, :text
  end
end
