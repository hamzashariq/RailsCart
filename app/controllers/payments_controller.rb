class PaymentsController < ApplicationController
  def new
    # fetch order using order_id param
    # fill the order summary in the view with the order details
  end

  def create
    # Put session creation logic in a service
  
    session = Stripe::Checkout::Session.create( 
      customer_email: current_user.email, 
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: {
            name: 'Custom Payment',
          },
          unit_amount: 400, # Amount in cents
        },
        quantity: 1,
      }],
      mode: 'payment',
      success_url:  success_payments_url,
      cancel_url: cancel_payments_url
     )

     redirect_to session.url, allow_other_host: true
  end

  def success
    #handle successful payments
    redirect_to root_url, notice: "Purchase Successful"
  end
  
  def cancel
    #handle if the payment is cancelled
    redirect_to root_url, notice: "Purchase Unsuccessful"
  end
end
