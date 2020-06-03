Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { registrations: 'users/registrations' }, defaults: { format: :json }
  resources :users, except: %i[new create edit]
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :homes, except: %i[new edit]
      resources :favorites, param: :user_home, only: %i[create index destroy]
    end
  end
end
