class Companies::RegistrationsController < ApplicationController
  skip_before_action :set_current_cart
  layout "landing"

  def new
    @company = Company.new
    @company.users.build
  end

  def create
    @company = Company.new(company_params)

    # Set the first user as an admin
    @company.users.first.admin = true if @company.users.first

    if @company.save
      # Sign in the newly created admin user
      sign_in(@company.users.first)

      flash[:notice] = "Your company has been successfully created!"
      # Disable Turbo for cross-domain redirects and allow redirecting to a different host
      redirect_to root_url(subdomain: @company.subdomain), allow_other_host: true
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def company_params
    params.require(:company).permit(
      :name,
      :subdomain,
      users_attributes: [:first_name, :last_name, :email, :password, :password_confirmation]
    )
  end
end
