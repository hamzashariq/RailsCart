ActiveAdmin.register Product do
  menu priority: 3

  # Filter options
  filter :name
  filter :price
  filter :stock
  filter :created_at

  # Index page
  index do
    selectable_column
    id_column
    column :name
    column :price do |product|
      number_to_currency(product.price)
    end
    column :stock
    column :created_at
    actions
  end

  # Show page
  show do
    attributes_table do
      row :id
      row :name
      row :price do |product|
        number_to_currency(product.price)
      end
      row :stock
      row :created_at
      row :updated_at
    end

    panel "In Carts" do
      table_for product.carts_products do
        column :cart do |cp|
          link_to "Cart ##{cp.cart.id}", admin_panel_cart_path(cp.cart) if cp.cart
        end
        column :quantity
        column :user do |cp|
          link_to cp.cart.user.name, admin_panel_user_path(cp.cart.user) if cp.cart && cp.cart.user
        end
      end
    end

    # Add active admin comments
    active_admin_comments
  end

  # Form
  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :price
      f.input :stock
    end
    f.actions
  end

  # Permit parameters
  permit_params :name, :price, :stock
end
