ActiveAdmin.register Order do
  menu priority: 4

  # Filter options
  filter :id
  filter :user
  filter :delivery_status
  filter :created_at

  # Disable creating new orders through admin panel
  actions :all, except: [:new, :create]

  # Index page
  index do
    selectable_column
    id_column
    column :user do |order|
      link_to order.user.name, admin_panel_user_path(order.user) if order.user
    end
    column :total do |order|
      number_to_currency(order.total)
    end
    column :delivery_status do |order|
      status_tag order.delivery_status
    end
    column :created_at
    actions
  end

  # Show page
  show do
    attributes_table do
      row :id
      row :user do |order|
        link_to order.user.name, admin_panel_user_path(order.user) if order.user
      end
      row :total do |order|
        number_to_currency(order.total)
      end
      row :delivery_status
      row :created_at
      row :updated_at
    end

    panel "Order Items" do
      table_for order.product_snapshots do
        column :name
        column :quantity
        column :price do |snapshot|
          number_to_currency(snapshot.price)
        end
        column :subtotal do |snapshot|
          number_to_currency(snapshot.price * snapshot.quantity)
        end
      end
    end

    panel "Delivery Information" do
      if order.delivery_information
        attributes_table_for order.delivery_information do
          row :first_name
          row :last_name
          row :email
          row :address
          row :city
          row :country
          row :number
        end
      else
        para "No delivery information available."
      end
    end
  end

  # Form for editing orders
  form do |f|
    f.inputs "Order Details" do
      f.input :delivery_status, as: :select, collection: ["pending", "processing", "shipped", "delivered", "cancelled"]
    end
    f.actions
  end

  # Permit parameters
  permit_params :delivery_status
end
