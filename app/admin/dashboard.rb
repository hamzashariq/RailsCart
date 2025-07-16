# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # Add Chart.js script
    script src: "https://cdn.jsdelivr.net/npm/chart.js"

    # Statistics Cards
    div class: "stats-grid" do
      div class: "stat-card" do
        div "Total Products", class: "label"
        div Product.count, class: "value"
        div "Active in catalog", class: "description"
      end
      div class: "stat-card" do
        div "Customers", class: "label"
        div User.where(user_type: "customer").count, class: "value"
        div "Registered users", class: "description"
      end
      div class: "stat-card" do
        div "Total Orders", class: "label"
        div Order.count, class: "value"
        div "All time", class: "description"
      end
      div class: "stat-card" do
        # Calculate average order value from product snapshots
        total_revenue = ProductSnapshot.joins(:order).sum("price * quantity")
        total_orders = Order.count
        avg_order_value = total_orders > 0 ? total_revenue / total_orders : 0
        div "Avg Order Value", class: "label"
        div number_to_currency(avg_order_value), class: "value"
        div "Per order", class: "description"
      end
      div class: "stat-card" do
        # Calculate monthly revenue from product snapshots
        monthly_revenue = ProductSnapshot.joins(:order)
          .where(orders: { created_at: 1.month.ago..Time.current })
          .sum("price * quantity")
        div "This Month", class: "label"
        div number_to_currency(monthly_revenue), class: "value"
        div "Revenue", class: "description"
      end
    end

    # Charts Row 1: Sales Over Time and Order Status
    div class: "chart-row" do
      panel "Sales Over Time (Last 30 Days)" do
        div class: "chart-container" do
          canvas id: "salesChart"
        end
      end

      panel "Order Status Distribution" do
        div class: "chart-container chart-small" do
          canvas id: "orderStatusChart"
        end
      end
    end

    # Charts Row 2: Top Products
    div class: "chart-full-width" do
      panel "Top 10 Products by Sales" do
        div class: "chart-container" do
          canvas id: "topProductsChart"
        end
      end
    end

    # Charts Row 3: Revenue Trends and User Growth
    div class: "chart-row" do
      panel "Monthly Revenue Trend (Last 12 Months)" do
        div class: "chart-container" do
          canvas id: "revenueChart"
        end
      end

      panel "User Registration Growth" do
        div class: "chart-container chart-small" do
          canvas id: "userGrowthChart"
        end
      end
    end

    # Recent Orders Table
    panel "Recent Orders" do
      table_for Order.includes(:user).order(created_at: :desc).limit(10) do
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

    # Chart.js Scripts
    script do
      # Prepare data for charts
      sales_data = (29.days.ago.to_date..Date.current).map do |date|
        {
          date: date.strftime("%m/%d"),
          sales: ProductSnapshot.joins(:order)
            .where(orders: { created_at: date.beginning_of_day..date.end_of_day })
            .sum("price * quantity")
        }
      end

      order_status_data = Order.group(:delivery_status).count

      # Top products by total sales value
      top_products_data = ProductSnapshot.joins(:order)
        .group(:name)
        .sum("price * quantity")
        .sort_by { |_, total| -total }
        .first(10)

      # Truncate product names for display but keep originals for tooltips
      top_products_labels = top_products_data.map do |name, _|
        name.length > 25 ? "#{name[0..22]}..." : name
      end
      top_products_full_names = top_products_data.map(&:first)
      top_products_values = top_products_data.map(&:last)

      # Monthly revenue for last 12 months
      monthly_revenue_data = (0..11).map do |i|
        month_start = i.months.ago.beginning_of_month
        month_end = i.months.ago.end_of_month
        {
          month: month_start.strftime("%b %Y"),
          revenue: ProductSnapshot.joins(:order)
            .where(orders: { created_at: month_start..month_end })
            .sum("price * quantity")
        }
      end.reverse

      # User growth data
      user_growth_data = (0..11).map do |i|
        month_start = i.months.ago.beginning_of_month
        month_end = i.months.ago.end_of_month
        {
          month: month_start.strftime("%b %Y"),
          users: User.where(user_type: "customer", created_at: month_start..month_end).count
        }
      end.reverse

      raw <<~JAVASCRIPT
        // Set dashboard data for external JavaScript file
        window.dashboardData = {
          salesData: {
            labels: #{sales_data.map { |d| d[:date] }.to_json},
            values: #{sales_data.map { |d| d[:sales] }.to_json}
          },
          orderStatusData: {
            labels: #{order_status_data.keys.map(&:humanize).to_json},
            values: #{order_status_data.values.to_json}
          },
          topProductsData: {
            labels: #{top_products_labels.to_json},
            values: #{top_products_values.to_json},
            fullNames: #{top_products_full_names.to_json}
          },
          monthlyRevenueData: {
            labels: #{monthly_revenue_data.map { |d| d[:month] }.to_json},
            values: #{monthly_revenue_data.map { |d| d[:revenue] }.to_json}
          },
          userGrowthData: {
            labels: #{user_growth_data.map { |d| d[:month] }.to_json},
            values: #{user_growth_data.map { |d| d[:users] }.to_json}
          }
        };
      JAVASCRIPT
    end
  end

  sidebar :help do
    para "Dashboard Analytics:"
    ul do
      li "Sales trends over the last 30 days"
      li "Order status distribution"
      li "Top-selling products"
      li "Monthly revenue trends"
      li "User registration growth"
    end
    para "Need help? Contact the system admin:"
    para "admin@example.com"
  end
end
