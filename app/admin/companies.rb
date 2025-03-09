ActiveAdmin.register Company do
  menu priority: 6

  # Only super admins should be able to manage companies
  actions :all

  # Filter options
  filter :name
  filter :subdomain
  filter :created_at

  # Index page
  index do
    selectable_column
    id_column
    column :name
    column :subdomain
    column "Users" do |company|
      company.users.count
    end
    column "Products" do |company|
      company.products.count
    end
    column :created_at
    actions
  end

  # Show page
  show do
    attributes_table do
      row :id
      row :name
      row :subdomain
      row :created_at
      row :updated_at
    end

    panel "Users" do
      table_for company.users do
        column :id
        column :name do |user|
          link_to user.name, admin_panel_user_path(user)
        end
        column :email
        column :user_type
        column :created_at
      end
    end

    panel "Products" do
      table_for company.products do
        column :id
        column :name do |product|
          link_to product.name, admin_panel_product_path(product)
        end
        column :price do |product|
          number_to_currency(product.price)
        end
        column :created_at
      end
    end
  end

  # Form
  form do |f|
    f.inputs "Company Details" do
      f.input :name
      f.input :subdomain
    end
    f.actions
  end

  # Permit parameters
  permit_params :name, :subdomain
end
