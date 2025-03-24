Rails.application.routes.draw do
  # System routes that don't require a subdomain
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # All application routes require a subdomain
  constraints(subdomain: /.+/) do
    devise_for :users

    ActiveAdmin.routes(self)

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

    resources :orders, only: [:create, :show] do
      member do
        patch :cancel
      end
    end

    resources :payments, only: [:new, :create] do
      collection do
        get :success
        get :cancel
      end
    end

    resource :user, only: [] do
      get "orders", on: :member
      get :settings
      patch :update_settings
    end
  end

  # Routes for the main domain (no subdomain)
  constraints(subdomain: "") do
    root "home#landing"  # Landing page for the main domain

    # Company Registration
    resource :company, only: [] do
      collection do
        get "sign_up", to: "companies/registrations#new", as: :new_registration
        post "sign_up", to: "companies/registrations#create", as: :registration
      end
    end
  end
end
