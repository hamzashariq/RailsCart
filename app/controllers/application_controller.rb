class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Pagy::Backend

  set_current_tenant_by_subdomain(:company, :subdomain)
  before_action :set_current_cart
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout :layout_by_resource

  private

  def authenticate_admin_user!
    authenticate_user!
    unless current_user && current_user.admin?
      flash[:alert] = "You are not authorized to access the admin panel."
      redirect_to root_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  def set_current_cart
    @current_cart = current_cart
  end

  def current_cart
    if current_user
      current_user.cart
    else
      Cart.find(session[:cart_id] ||= create_guest_cart.id)
    end
  end

  def create_guest_cart
    Cart.create(company_id: current_tenant.id).tap { |cart| session[:cart_id] = cart.id }
  end

  def layout_by_resource
    if devise_controller?
      "auth"
    else
      "application"
    end
  end
end
