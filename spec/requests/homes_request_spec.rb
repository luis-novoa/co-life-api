require 'rails_helper'
require 'spec_helper'

RSpec.describe "Homes", type: :request do
  describe "POST /api/v1/homes" do
    subject { build(:home) }

    context "without authentication key" do
      before(:each) { post "/api/v1/homes" }
      it "responds with 401" do
        expect(response).to have_http_status(401)
      end

      it "returns error message" do
        expect(response.body).to match(/This action requires an authentication token./)
      end
    end

    context "with missing information" do
      before(:each) do
        headers = {
          'X-User-Email' => subject.user.email,
          'X-User-Token' => subject.user.authentication_token
        }
        parameters = {
          home: {
            title: subject.title
          }
        }
        post '/api/v1/homes', params: parameters, headers: headers
      end

      it "responds with 422" do
        expect(response).to have_http_status(422)
      end

      it "returns errors" do
        expect(response.body).to match(/can't be blank/)
      end
    end

    context "with current user id and correct information" do
      before(:each) do
        headers = {
          'X-User-Email' => subject.user.email,
          'X-User-Token' => subject.user.authentication_token
        }
        parameters = {
          home: {
            title: subject.title,
            address: subject.address,
            city: subject.city,
            country: subject.country,
            rent: subject.rent,
            room_type: subject.room_type,
            more_info: subject.more_info
          }
        }
        post '/api/v1/homes', params: parameters, headers: headers
      end
      it 'responds with 201' do
        expect(response).to have_http_status(201)
      end

      it "returns user info" do
        expect(response.body).to match(/#{subject.address}/)
      end
    end

    context "with other user id and correct information" do
      let(:other_user) { create(:user, :saved) }
      before(:each) do
        headers = {
          'X-User-Email' => subject.user.email,
          'X-User-Token' => subject.user.authentication_token
        }
        parameters = {
          home: {
            title: subject.title,
            address: subject.address,
            city: subject.city,
            country: subject.country,
            rent: subject.rent,
            room_type: subject.room_type,
            more_info: subject.more_info,
            user_id: other_user.id
          }
        }
        post '/api/v1/homes', params: parameters, headers: headers
      end

      it 'responds with 201' do
        expect(response).to have_http_status(201)
      end
      
      it 'ignores attempt to determine user_id' do
        expect(Home.find_by(address: subject.address).user_id).to eq(subject.user.id) 
      end
    end
  end
end
