class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def orders
    @pagy, @orders = pagy(
      current_user.orders.includes(:product_snapshots, :delivery_information)
                        .order(created_at: :desc),
      limit: 10
    )
  end

  def settings
  end

  def update_settings
    if user_params[:password].blank?
      params = user_params.except(:password, :password_confirmation)
      success = @user.update(params)
    else
      success = @user.update(user_params)
    end

    if success
      bypass_sign_in(@user)
      flash[:notice] = "Profile updated successfully."
      redirect_to settings_user_path
    else
      render turbo_stream: turbo_stream.replace(
        "user_settings_form",
        partial: "users/settings_form",
        locals: { user: @user }
      )
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email,
                               :password, :password_confirmation, :avatar)
  end
end
