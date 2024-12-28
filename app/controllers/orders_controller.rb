class OrdersController < ApplicationController
  def create
    # create order and redirect to payments controller
    order_creation_result = Orders::OrderCreator.call(current_cart, current_user, delivery_information_params)

    redirect_to new_payment_path(order_id: order_creation_result.order.id)



    # You might need to use stripe connect https://claude.ai/chat/1096f850-dc72-4a92-800a-7660eb639fd1
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
