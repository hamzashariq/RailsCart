module Orders
  class OrderCreator    
    attr_reader :cart, :user, :delivery_information_params, :order
    
    def initialize(cart, user, delivery_information_params)
      @cart = cart
      @user = user
      @delivery_information_params = delivery_information_params
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      ActiveRecord::Base.transaction do
        create_order!
        create_product_snapshots!
        empty_cart!

        OpenStruct.new(success?: true, order: order)
      end
    rescue StandardError => e
      OpenStruct.new(success?: false, errors: e.message)
    end

    private

    def create_order!
      @order = order = Order.create!(
        user: user,
        delivery_information_attributes: delivery_information_params
      )
    end

    def create_product_snapshots!
      cart.carts_products.each do |cart_product|
        ProductSnapshot.create!(
          order: order,
          name: cart_product.product.name,
          price: cart_product.product.price,
          quantity: cart_product.quantity
        )
      end
    end

    def empty_cart!
      cart.empty!
    end
  end
end
