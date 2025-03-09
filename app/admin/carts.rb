ActiveAdmin.register Cart do
  menu priority: 5

  # Filter options
  filter :id
  filter :user
  filter :created_at

  # Disable creating/editing carts through admin panel
  actions :all, except: [:new, :create, :edit, :update]

  # Index page
  index do
    selectable_column
    id_column
    column :user do |cart|
      link_to cart.user.name, admin_panel_user_path(cart.user) if cart.user
    end
    column "Item Count" do |cart|
      cart.total_items
    end
    column "Total Value" do |cart|
      number_to_currency(cart.total_price)
    end
    column :created_at
    actions
  end

  # Show page
  show do
    attributes_table do
      row :id
      row :user do |cart|
        link_to cart.user.name, admin_panel_user_path(cart.user) if cart.user
      end
      row :created_at
      row :updated_at
    end

    panel "Cart Items" do
      table_for cart.carts_products do
        column :product do |cp|
          link_to cp.product.name, admin_panel_product_path(cp.product) if cp.product
        end
        column :quantity
        column "Unit Price" do |cp|
          number_to_currency(cp.product.price) if cp.product
        end
        column "Subtotal" do |cp|
          number_to_currency(cp.product.price * cp.quantity) if cp.product
        end
      end
    end
  end
end
