require 'rails_helper'
require 'spec_helper'

RSpec.describe 'User request', type: :request do
  describe "POST /users" do
    let(:test_user) { build(:user) }
    context "with missing information" do
      it "responds with 422" do
        parameters = {
          user: {
            name: test_user.name
          }
        }
        post '/users', params: parameters
        expect(response).to have_http_status(422)
      end

      it "returns errors" do
        parameters = {
          user: {
            name: test_user.name
          }
        }
        post '/users', params: parameters
        expect(response.body).to match(/errors/)
      end
    end

    context "with unfilled password confirmation" do
      it "returns errors" do
        parameters = {
          user: {
            name: test_user.name,
            email: test_user.email,
            password: test_user.password,
            password_confirmation: nil
          }
        }
        post '/users', params: parameters
        expect(response.body).to match(/errors/)
      end
    end
    

    context "with correct information" do
      it "responds with 201" do
        parameters = {
          user: {
            name: test_user.name,
            email: test_user.email,
            password: test_user.password,
            password_confirmation: test_user.password
          }
        }
        post '/users', params: parameters
        expect(response).to have_http_status(201)
      end

      it "creates new user" do
        parameters = {
          user: {
            name: test_user.name,
            email: test_user.email,
            password: test_user.password,
            password_confirmation: test_user.password
          }
        }
        post '/users', params: parameters
        expect(User.count).to eq(1)
      end
    end
  end

  describe "GET /users/:id" do
    subject { create(:user, :saved) } 

    context "without authentication key" do
      before(:each) { get "/users/#{subject.id}" }
      it "responds with 401" do
        expect(response).to have_http_status(401)
      end

      it "returns error message" do
        expect(response.body).to match(/This action requires an authentication token./)
      end
    end

    context "with current user id" do
      before(:each) do 
        headers = {
          'X-User-Email' => subject.email,
          'X-User-Token' => subject.authentication_token
        }
        get "/users/#{subject.id}", headers: headers
      end
      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it "returns user info" do
        expect(response.body).to match(/#{subject.email}/)
      end
    end

    context "with other user id" do
      let(:other_user) { create(:user, :saved) }

      before(:each) do
        headers = {
          'X-User-Email' => subject.email,
          'X-User-Token' => subject.authentication_token
        }
        get "/users/#{other_user.id}", headers: headers
      end

      it "responds with 401" do
        expect(response).to have_http_status(401)
      end

      it "returns error message" do
        expect(response.body).to match(/This action isn't allowed for your account./)
      end
    end

    context "with other user id by an admin" do
      let(:other_user) { create(:user, :saved) }

      before(:each) do
        headers = {
          'X-User-Email' => subject.email,
          'X-User-Token' => subject.authentication_token
        }
        subject.update(admin: true)
        get "/users/#{other_user.id}", headers: headers
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it "returns other user's info" do
        expect(response.body).to match(/#{other_user.email}/)
      end

      it "hides other user's authentication token" do
        expect(response.body).to_not match(/#{other_user.authentication_token}/)
      end
    end
  end
end