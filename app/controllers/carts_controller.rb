class CartsController < ApplicationController
  def show
    @cart = find_cart
  end

  private

  def find_cart
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
