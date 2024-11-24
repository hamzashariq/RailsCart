class CartsController < ApplicationController
  def show
    @cart = current_cart
    @carts_products = @cart.carts_products.includes(:product).order(:created_at)
  end

  def checkout

  end

  def complete_checkout
    # create order and redirect to payments controller
    order_creation_result = Orders::OrderCreator.call(current_cart, current_user, delivery_information_params)

    # work on adding the order status enum, set order status to pending in the order creation service
  end

  private

  def delivery_information_params
    params
      .require(:delivery_information)
      .permit(
        :first_name,
        :last_name,
        :email,
        :address,
        :number,
        :city,
        :country
      )
  end
end
