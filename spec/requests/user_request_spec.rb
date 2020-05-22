require 'rails_helper'
require 'spec_helper'

RSpec.describe 'User requests', type: :request do
  describe "POST /api/v1/users" do
    let(:test_user) { build(:user) }
    it "responds with 400 if there's missing information" do
      parameters = "{
        \"user\": {
          \"name\": \"#{test_user.name}\"
        }
      }"
      post '/api/v1/users', params: parameters
      expect(response).to have_http_status(400)
    end
  end
end