module ApplicationHelper
  def cart_item_count
    if current_user
      current_user.cart.total_items
    else
      Cart.find(session[:cart_id]).total_items
    end
  end
end
