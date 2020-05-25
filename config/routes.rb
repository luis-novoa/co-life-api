Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { registrations: 'users/registrations' }, defaults: { format: :json }
  # scope :api, defaults: { format: :json } do
  #   scope :v1 do
  #   end
  # end
end
