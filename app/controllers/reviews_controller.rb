class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product

  def create
    @review = @product.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      flash[:notice] = "Review was successfully created."
      redirect_to product_path(@product)
    else
      flash[:alert] = @review.errors.full_messages.join
      redirect_to product_path(@product)
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def review_params
    params.require(:review).permit(:rating, :description, images: [])
  end
end
