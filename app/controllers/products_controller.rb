class ProductsController < ApplicationController
  def index
    @products = Product.all
    test = 1
  end

  def show
    @product = Product.find(params[:id])
  end
end
