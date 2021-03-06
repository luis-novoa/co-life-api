module API::V1
  class APIController < ApplicationController
    acts_as_token_authentication_handler_for User, fallback_to_devise: false
    before_action :require_authentication!

    private

    def check_if_ad_exists(param)
      return render json: "This ad doesn't exist.", status: :not_found unless Home.exists?(id: param)
    end
  end
end
