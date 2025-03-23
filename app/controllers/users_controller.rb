class UsersController < ApplicationController
  before_action :authenticate_user!

  def orders
    @pagy, @orders = pagy(
      current_user.orders.includes(:product_snapshots, :delivery_information)
                        .order(created_at: :desc),
      limit: 10
    )
  end
end
