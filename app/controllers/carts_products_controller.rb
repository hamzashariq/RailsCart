class CartsProductsController < ApplicationController
  def increment
    cart_product = current_cart.carts_products.find(params[:id])
    cart_product.update!(quantity: cart_product.quantity + 1)

    render turbo_stream: [
      turbo_stream.replace("cart-product-#{cart_product.id}", partial: "carts/cart_product", locals: { cart_product: cart_product }),
      turbo_stream.replace("cart-item-count", partial: "layouts/cart_item_count", locals: { cart_item_count: current_cart.total_items })
    ]
  end

  def decrement
    cart_product = current_cart.carts_products.find(params[:id])

    if cart_product.quantity > 1
      cart_product.update!(quantity: cart_product.quantity - 1)
      render turbo_stream: [
        turbo_stream.replace("cart-product-#{cart_product.id}", partial: "carts/cart_product", locals: { cart_product: cart_product }),
        turbo_stream.replace("cart-item-count", partial: "layouts/cart_item_count", locals: { cart_item_count: current_cart.total_items })
    ]
    else
      cart_product.destroy
      render turbo_stream: [
        turbo_stream.remove("cart-product-#{cart_product.id}"),
        turbo_stream.replace("cart-item-count", partial: "layouts/cart_item_count", locals: { cart_item_count: current_cart.total_items })
      ]
    end
  end

  def destroy
    cart_product = current_cart.carts_products.find(params[:id])

    cart_product.destroy
    render turbo_stream: [
      turbo_stream.remove("cart-product-#{cart_product.id}"),
      turbo_stream.replace("cart-item-count", partial: "layouts/cart_item_count", locals: { cart_item_count: current_cart.total_items })
    ]
  end

  def add_to_cart
    product = Product.find(params[:product_id])

    cart_product = current_cart.carts_products.find_or_initialize_by(product: product)
    
    if cart_product.new_record?
      cart_product.quantity = 1
    else
      cart_product.quantity += 1
    end

    cart_product.save

    render turbo_stream: turbo_stream.replace("cart-item-count", partial: "layouts/cart_item_count", locals: { cart_item_count: current_cart.total_items })
  end
end
