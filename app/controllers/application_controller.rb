class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def current_cart
    if current_user
      current_user.cart
    else
      Cart.find(session[:cart_id] ||= create_guest_cart.id)
    end
  end

  def create_guest_cart
    Cart.create.tap { |cart| session[:cart_id] = cart.id }
  end
end
