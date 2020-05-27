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

      it "returns user's info" do
        expect(response.body).to match(/#{subject.address}/)
      end

      it 'adds info to the database' do
        expect(Home.count).to eq(1)
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

  describe "GET /api/v1/homes/:id" do
    subject { create(:home) }

    context "without authentication key" do
      before(:each) { get "/api/v1/homes/#{subject.id}" }
      it "responds with 200" do
        expect(response).to have_http_status(200)
      end

      it "returns home ad information" do
        expect(response.body).to match(/#{subject.address}/)
      end
    end

    context "with inexistent id" do
      before(:each) { get "/api/v1/homes/1" }
      it "responds with 404" do
        expect(response).to have_http_status(404)
      end

      it "returns warning" do
        expect(response.body).to match(/This ad doesn't exist./)
      end
    end
  end

  describe "GET /api/v1/homes" do
    context "without authentication key" do
      before(:each) do
        create_list(:home, 5)
        get "/api/v1/homes" 
      end
      it "responds with 200" do
        expect(response).to have_http_status(200)
      end

      it "returns list of home ads" do
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(5)
      end
    end
  end
end
