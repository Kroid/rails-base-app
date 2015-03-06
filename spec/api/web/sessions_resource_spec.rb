require 'rails_helper'

RSpec.describe Web::SessionsResource do
  describe 'create session' do
    let(:user) { FactoryGirl.create :user }
    let(:uri)  { '/api/web/sessions.json' }
    let(:request_params) { {email: user.email, password: user.password, uuid: Faker::Lorem.characters(25)} }

    Device::PLATFORMS.each do |platform|
      context "when request params are valid and platform \"#{platform}\"" do
        before { post uri, request_params.merge(:platform => platform) }

        it 'does responde with 201 status' do
          expect_status 201.to_s
        end

        it 'does responde with "authentication_token"' do
          expect_json('device.authentication_token', user.devices.last.authentication_token)
        end
      end
    end

    describe 'when requires request params are empty' do
      let(:request_params) { {email: user.email, password: user.password, uuid: Faker::Lorem.characters(25), platform: 'browser'} }

      context 'all' do
        before { post uri, {} }

        it 'does responde with 400 status' do
          expect_status 400.to_s
        end
      end

      context 'email' do
        before { post uri, request_params.merge(email: '') }

        it 'does responde with 422 status' do
          expect_status 422.to_s
        end
      end

      context 'password' do
        before { post uri, request_params.merge(password: '') }

        it 'does responde with 422 status' do
          expect_status 422.to_s
        end
      end

      context 'platform' do
        before { post uri, request_params.merge(platform: '') }

        it 'does responde with 400 status' do
          expect_status 400.to_s
        end
      end
    end

    describe 'when request params are invalid' do
      let(:request_params) { {email: user.email, password: user.password, uuid: Faker::Lorem.characters(25), platform: 'browser'} }

      context 'email' do
        before { post uri, request_params.merge(email: user.email*2) }

        it 'does responde with 422 status' do
          expect_status 422.to_s
        end

        # it 'does responde with message' do
        #   expect_json('error', 'email does not have a valid value')
        # end
      end

      context 'password' do
        before { post uri, request_params.merge(password: user.password*2) }

        it 'does responde with 422 status' do
          expect_status 422.to_s
        end

        # it 'does responde with message' do
        #   expect_json('error', 'password does not have a valid value')
        # end
      end

      context 'platform' do
        before { post uri, request_params.merge(platform: 'invalid_platform') }

        it 'does responde with 400 status' do
          expect_status 400.to_s
        end

        it 'does responde with message' do
          expect_json('error', 'platform does not have a valid value')
        end
      end
    end

  end

  describe 'destroy session' do
    let(:device) { FactoryGirl.create(:device) }
    let(:uri)  { '/api/web/sessions.json' }

    context 'when request authentication token is valid' do
      before { delete uri, {authentication_token: device.authentication_token} }

      it 'does responde with 200 status' do
        expect_status 200.to_s
      end

      it 'does change authentication_token' do
        expect(Device.find(device.id).authentication_token).to_not eq(device.authentication_token)
      end
    end

    context 'when request authentication token is invalid' do
      before { delete uri, {authentication_token: 'invalid_token'} }

      it 'does responde with 200 status' do
        expect_status 200.to_s
      end

      it 'does not change authentication_token' do
        expect(Device.find(device.id).authentication_token).to eq(device.authentication_token)
      end
    end
  end
end
