require 'rails_helper'
require 'spec_helper'

# RSpec.describe "Favorites", type: :request do
#   describe "POST api/v1/favorites" do
#     subject { create(:user) } 
#     context "without authentication key" do
#       before(:each) { post "/api/v1/favorites" }
#       it "responds with 401" do
#         expect(response).to have_http_status(401)
#       end

#       it "returns error message" do
#         expect(response.body).to match(/This action requires an authentication token./)
#       end
#     end

#     context "with missing information" do
#       before(:each) do
#         headers = {
#           'X-User-Email' => subject.user.email,
#           'X-User-Token' => subject.user.authentication_token
#         }
#         parameters = {
#           home: {
#             title: subject.title
#           }
#         }
#         post '/api/v1/homes', params: parameters, headers: headers
#       end

#       it "responds with 422" do
#         expect(response).to have_http_status(422)
#       end

#       it "returns errors" do
#         expect(response.body).to match(/can't be blank/)
#       end
#     end
#   end
# end
