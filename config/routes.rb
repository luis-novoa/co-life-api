Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope :api, :defaults => {:format => :json} do
    scope :v1 do
      devise_for :users, controllers: { registrations: 'api/v1/users/registrations' }
    end
  end
end
