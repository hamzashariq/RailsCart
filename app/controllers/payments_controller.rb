class PaymentsController < ApplicationController
  def new
    @order = current_user.orders.find(params[:order_id])
  end

  def create
    @order = current_user.orders.find(params[:order_id])

    session = Stripe::Checkout::Session.create(
      customer_email: current_user.email,
      line_items: [{
        price_data: {
          currency: "usd",
          product_data: {
            name: "Order ##{@order.id}"
          },
          unit_amount: (@order.total * 100).to_i # Convert to cents
        },
        quantity: 1
      }],
      mode: "payment",
      success_url: success_payments_url(order_id: @order.id),
      cancel_url: cancel_payments_url(order_id: @order.id)
     )

     redirect_to session.url, allow_other_host: true
  end

  def success
    @order = Order.find(params[:order_id])
    @order.update!(delivery_status: :confirmed)

    redirect_to order_path(@order), notice: "Payment successful! Your order has been confirmed."
  end

  def cancel
    @order = Order.find(params[:order_id])
    redirect_to order_path(@order), alert: "Payment was cancelled. Please try again."
  end
end
