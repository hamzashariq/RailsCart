# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Orders" do
          table_for Order.includes(:user).order(created_at: :desc).limit(5) do
            column("Order ID") { |order| link_to("##{order.id}", admin_panel_order_path(order)) }
            column("Date") { |order| status_tag(order.created_at.strftime("%B %d, %Y")) }
            column("Customer") { |order| link_to(order.user.name, admin_panel_user_path(order.user)) if order.user }
            column("Total") { |order| number_to_currency(order.total) }
            column("Status") { |order| status_tag(order.delivery_status) }
          end
          div do
            link_to "View All Orders", admin_panel_orders_path, class: "button"
          end
        end
      end

      column do
        panel "Statistics" do
          div class: "dashboard-stats" do
            ul do
              li do
                span "Products", class: "stat-label"
                span Product.count, class: "stat-value"
              end
              li do
                span "Registered Users", class: "stat-label"
                span User.where(user_type: "customer").count, class: "stat-value"
              end
              li do
                span "Admin Users", class: "stat-label"
                span User.where(user_type: "admin").count, class: "stat-value"
              end
              li do
                span "Total Orders", class: "stat-label"
                span Order.count, class: "stat-value"
              end
              li do
                span "Average Order Value", class: "stat-label"
                avg = Order.count > 0 ? Order.all.map(&:total).sum / Order.count : 0
                span number_to_currency(avg), class: "stat-value"
              end
            end
          end
        end

        panel "Recent Activity" do
          para "Welcome to your E-commerce Admin Panel."
          para "Use the navigation to manage your products, orders, and users."
        end
      end
    end
  end

  sidebar :help do
    para "Need help? Contact the system admin:"
    para "admin@example.com"
  end
end
