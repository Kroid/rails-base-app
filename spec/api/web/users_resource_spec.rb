require 'rails_helper'

RSpec.describe Web::UsersResource do
  describe 'create user' do
    let(:user) { FactoryGirl.build :user }
    let(:uri)  { '/api/web/users.json' }
    let(:request_params) { {email: user.email, password: user.password, uuid: Faker::Lorem.characters(25)} }

    Device::PLATFORMS.each do |platform|
      context "when request params are valid and platform \"#{platform}\"" do
        before { post uri, request_params.merge(:platform => platform) }

        it 'does responde with 201 status' do
          expect_status 201.to_s
        end

        it 'does responde with "authentication_token"' do
          expect_json('device.authentication_token', User.last.devices.last.authentication_token)
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

      # context 'password' do
      #   before { post uri, request_params.merge(password: user.password*2) }

      #   it 'does responde with 422 status' do
      #     expect_status 422.to_s
      #   end

      #   # it 'does responde with message' do
      #   #   expect_json('error', 'password does not have a valid value')
      #   # end
      # end

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
end
