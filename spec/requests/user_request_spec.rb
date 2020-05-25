require 'rails_helper'
require 'spec_helper'

RSpec.describe 'User request', type: :request do
  describe "POST /api/v1/users" do
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
end