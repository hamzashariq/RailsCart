class HomeController < ApplicationController
  skip_before_action :set_current_cart, only: [:landing]

  def index
  end

  def landing
    render layout: "landing"
  end
end
