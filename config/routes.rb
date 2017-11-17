Rails.application.routes.draw do
  root to: 'static_pages#root'

  namespace :api, defaults: { format: :json } do
    resource :session, only: [:create, :destroy]
    get '/auth/:provider/callback' => 'social_auth/omniauth_callbacks#authenticate'

    # Password recovery routes
    post '/users/password' => "passwords#create", as: :user_password_reset
    get '/users/password/edit' => "passwords#edit", as: :edit_user_password_reset
    put '/users/password' => "passwords#update", as: :update_user_password_reset

    resources :users, except: [:new, :edit, :destroy] do
      collection do
        get :current
      end
    end

    # Account confirmation route after signup
    get '/users/confirmation/:confirmation_token' => "confirmations#show", as: :user_confirmation

    resources :questions, except: [:new, :edit] do
      collection do
        get :search
        get :category_index
      end
    end
    resources :votes, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy, :update]
    resources :answers, only: [:create, :destroy, :update]
    resources :tags, only: [:index, :show, :create]
    resources :badges, only: [:index, :show]
    resource :search, only: [] do
      collection do
        get :query
      end
    end
  end
end
