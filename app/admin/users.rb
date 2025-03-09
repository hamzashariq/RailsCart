ActiveAdmin.register User do
  menu priority: 2

  # The filter sidebar options
  filter :email
  filter :first_name
  filter :last_name
  filter :user_type, as: :select, collection: ["admin", "customer"]
  filter :created_at

  # Set the available actions
  actions :all

  # Index page configuration
  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :user_type
    column :created_at
    actions
  end

  # Show page configuration
  show do
    attributes_table do
      row :id
      row :email
      row :first_name
      row :last_name
      row :user_type
      row :company
      row :created_at
      row :updated_at
    end

    panel "Orders" do
      table_for user.orders do
        column :id do |order|
          link_to order.id, admin_panel_order_path(order)
        end
        column :total
        column :created_at
      end
    end

    panel "Cart" do
      if user.cart
        table_for user.cart.carts_products do
          column :product do |cp|
            link_to cp.product.try(:name), admin_panel_product_path(cp.product) if cp.product
          end
          column :quantity
          column :price do |cp|
            number_to_currency(cp.product.try(:price))
          end
        end
      else
        para "No cart found for this user."
      end
    end
  end

  # Form configuration
  form do |f|
    f.inputs "User Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :user_type, as: :select, collection: ["admin", "customer"]
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  # Permit parameters
  permit_params :first_name, :last_name, :email, :user_type, :password, :password_confirmation
end
