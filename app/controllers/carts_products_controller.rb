class CartsProductsController < ApplicationController
  def delete
  end

  def increment
    @cart_product = current_user.cart.carts_products.find(params[:id])
    @cart_product.update!(quantity: @cart_product.quantity + 1)

    render turbo_stream: turbo_stream.replace("cart-item-#{@cart_product.id}", partial: "carts/cart_product", locals: { cart_product: @cart_product })
  end

  def decrement
    @cart_product = current_user.cart.carts_products.find(params[:id])

    if @cart_product.quantity > 1
      @cart_product.update!(quantity: @cart_product.quantity - 1)
    end

    render turbo_stream: turbo_stream.replace("cart-item-#{@cart_product.id}", partial: "carts/cart_product", locals: { cart_product: @cart_product })
  end
end
