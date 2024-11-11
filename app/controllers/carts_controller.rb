class CartsController < ApplicationController
  def show
    @cart = current_cart
    @carts_products = @cart.carts_products.includes(:product).order(:created_at)
  end

  def checkout
    
  end
end
