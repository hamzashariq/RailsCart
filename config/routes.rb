Rails.application.routes.draw do
  # System routes that don't require a subdomain
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # All application routes require a subdomain
  constraints(subdomain: /.+/) do
    devise_for :users

    # Root path for subdomains
    root "home#index", as: :subdomain_root

    resources :products, only: [:index, :show]

    resource :cart, only: [:show] do
      member do
        get :checkout
      end

      resources :carts_products, only: [:destroy] do
        member do
          patch :increment
          patch :decrement
        end

        collection do
          post :add_to_cart
        end
      end
    end

    resources :orders, only: [:create]

    resources :payments, only: [:new, :create] do
      collection do
        get :success
        get :cancel
      end
    end
  end

  # Routes for the main domain (no subdomain)
  constraints(subdomain: "") do
    root "home#landing"  # Landing page for the main domain
  end
end
