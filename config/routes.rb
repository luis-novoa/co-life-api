Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { registrations: 'users/registrations' }, defaults: { format: :json }
  resources :users, only: [:show, :index, :destroy, :update]
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :homes, only: [:create, :show, :index, :update, :destroy]
    end
  end
end
