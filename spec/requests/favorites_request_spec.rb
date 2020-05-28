require 'rails_helper'
require 'spec_helper'

RSpec.describe "Favorites", type: :request do
  describe "POST api/v1/favorites" do
    subject { build(:favorite) } 
    context "without authentication key" do
      before(:each) { post "/api/v1/favorites" }
      it "responds with 401" do
        expect(response).to have_http_status(401)
      end

      it "returns error message" do
        expect(response.body).to match(/This action requires an authentication token./)
      end
    end

    context "with existing home ad" do
      before(:each) do
        headers = {
          'X-User-Email' => subject.user.email,
          'X-User-Token' => subject.user.authentication_token
        }
        parameters = {
          favorite: {
            home_id: subject.home_id
          }
        }
        post '/api/v1/favorites', params: parameters, headers: headers
      end

      it "responds with 201" do
        expect(response).to have_http_status(201)
      end

      it "returns favorite information" do
        expect(response.body).to match(/#{subject.user_home}/)
      end
    end

    context "with inexistent home ad" do
      before(:each) do
        headers = {
          'X-User-Email' => subject.user.email,
          'X-User-Token' => subject.user.authentication_token
        }
        parameters = {
          favorite: {
            home_id: subject.home_id + 1
          }
        }
        post '/api/v1/favorites', params: parameters, headers: headers
      end
      it "responds with 404" do
        expect(response).to have_http_status(404)
      end

      it "returns warning" do
        expect(response.body).to match(/This ad doesn't exist./)
      end
    end

    context "with repeated home ad" do
      before(:each) do
        headers = {
          'X-User-Email' => subject.user.email,
          'X-User-Token' => subject.user.authentication_token
        }
        parameters = {
          favorite: {
            home_id: subject.home_id
          }
        }
        subject.save
        post '/api/v1/favorites', params: parameters, headers: headers
      end
      it "responds with 422" do
        expect(response).to have_http_status(422)
      end

      it "returns warning" do
        expect(response.body).to match(/has already been taken/)
      end
    end
  end

  describe "GET api/v1/favorites" do
    subject { create(:user, :saved, :favorite_list) } 
    context "without authentication key" do
      before(:each) { post "/api/v1/favorites" }
      it "responds with 401" do
        expect(response).to have_http_status(401)
      end

      it "returns error message" do
        expect(response.body).to match(/This action requires an authentication token./)
      end
    end
  end
end
