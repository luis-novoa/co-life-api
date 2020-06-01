require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Favorites', type: :request do
  describe 'POST api/v1/favorites' do
    subject { build(:favorite) }
    context 'without authentication key' do
      before(:each) { post '/api/v1/favorites' }
      it 'responds with 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns error message' do
        expect(response.body).to match(/This action requires an authentication token./)
      end
    end

    context 'with existing home ad' do
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

      it 'responds with 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns favorite information' do
        expect(response.body).to match(/#{subject.to_json(only: %i[user_id home_id])}/)
      end
    end

    context 'with inexistent home ad' do
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
      it 'responds with 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns warning' do
        expect(response.body).to match(/This ad doesn't exist./)
      end
    end

    context 'with repeated home ad' do
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
      it 'responds with 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns warning' do
        expect(response.body).to match(/has already been taken/)
      end
    end
  end

  describe 'GET api/v1/favorites' do
    subject { create(:user, :saved, :favorite_list) }

    context 'without authentication key' do
      before(:each) { post '/api/v1/favorites' }
      it 'responds with 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns error message' do
        expect(response.body).to match(/This action requires an authentication token./)
      end
    end

    context 'with common account' do
      let!(:other_user) { create(:user, :saved, :favorite_list) }
      before(:each) do
        headers = {
          'X-User-Email' => subject.email,
          'X-User-Token' => subject.authentication_token
        }
        get '/api/v1/favorites', headers: headers
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it "returns the user's favorite ads ids" do
        expect(response.body).to match(/#{subject.favorites.to_json(only: %i[user_id home_id])}/)
      end

      it "doesn't return other user's favorite ads ids" do
        expect(response.body).to_not match(/"user": #{other_user.id}/)
      end
    end

    context 'with admin account' do
      let(:admin) { create(:user, :saved) }
      before(:each) do
        headers = {
          'X-User-Email' => admin.email,
          'X-User-Token' => admin.authentication_token
        }
        admin.update(admin: true)
        create_list(:favorite, 5)
        get '/api/v1/favorites', headers: headers
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all favorite ads relations' do
        expect(response.body).to match(/#{Favorite.all.to_json(only: %i[user_id home_id])}/)
      end
    end
  end

  describe 'DELETE api/v1/favorites/:user_home' do
    subject { create(:favorite) }

    context 'without authentication key' do
      before(:each) { delete "/api/v1/favorites/#{subject.user_home}" }
      it 'responds with 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns error message' do
        expect(response.body).to match(/This action requires an authentication token./)
      end
    end

    context "with current user's favorite" do
      before(:each) do
        headers = {
          'X-User-Email' => subject.user.email,
          'X-User-Token' => subject.user.authentication_token
        }
        delete "/api/v1/favorites/#{subject.user_home}", headers: headers
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns success message' do
        expect(response.body).to match(/Ad removed from your favorites list!/)
      end

      it 'deletes home ad from favorites' do
        expect(subject.user.favorites).to_not include(subject)
      end
    end

    context "with other user's favorite" do
      before(:each) do
        headers = {
          'X-User-Email' => subject.home.user.email,
          'X-User-Token' => subject.home.user.authentication_token
        }
        delete "/api/v1/favorites/#{subject.user_home}", headers: headers
      end

      it 'responds with 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns failure message' do
        expect(response.body).to match(/Favorite relation doesn't belong to this user./)
      end

      it "doesn't delete home ad from other user's favorites" do
        expect(subject.user.favorites).to include(subject)
      end
    end

    context 'with inexistent favorite' do
      let(:user) { subject.user }
      before(:each) do
        headers = {
          'X-User-Email' => subject.user.email,
          'X-User-Token' => subject.user.authentication_token
        }
        delete "/api/v1/favorites/#{subject.user_id}_#{subject.home_id - 1}", headers: headers
      end

      it 'responds with 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns failure message' do
        expect(response.body).to match(/Favorite relation doesn't belong to this user./)
      end
    end
  end
end
