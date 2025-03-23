class UsersController < ApplicationController
  before_action :authenticate_user!

  def orders
    @orders = current_user.orders.includes(:product_snapshots, :delivery_information)
                         .order(created_at: :desc)
  end
end
