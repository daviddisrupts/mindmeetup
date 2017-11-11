Rails.application.routes.draw do
  root to: 'static_pages#root'

  namespace :api, defaults: { format: :json } do
    resource :session, only: [:create, :destroy]
    resources :users, except: [:new, :edit, :destroy] do
      collection do
        get :current
      end
    end
    get '/users/confirmation/:confirmation_token' => "confirmation#show", as: :user_confirmation
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
