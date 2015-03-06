require 'rails_helper'

RSpec.describe Device, type: :model do
  let(:device) { FactoryGirl.build :device }

  it { expect(device).to be_valid }

  describe 'associations' do
    it { expect(device).to belong_to(:user) }
  end

  describe 'validations' do
    it { expect(device).to validate_presence_of :user }

    it { expect(device).to validate_presence_of   :uuid }
    it { expect(device).to validate_uniqueness_of :uuid }

    it { expect(device).to validate_presence_of  :platform }
    it { expect(device).to validate_inclusion_of(:platform).in_array(['ios', 'android', 'browser']) }
  end

  describe 'callbacks' do
    let(:device) { FactoryGirl.create(:device, :authentication_token => 'token') }

    it { expect(device).to callback(:update_authentication_token).after(:create) }
    it { expect(device).to callback(:update_authentication_token).after(:update) }
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { expect(device).to respond_to(:update_authentication_token) }
    end

    context 'executes correctly' do
      describe '.update_authentication_token' do
        it 'update authentication token' do
          expect(device.authentication_token).not_to eql('token')
        end
      end
    end
  end

  describe 'class methods' do
    context 'responds to its methods' do
      it { expect(Device).to respond_to(:create_session) }
    end

    context 'executes correctly' do
      describe '.create_session' do
        let (:user) { FactoryGirl.create(:user) }

        it 'when device doesn\'t exist' do
          tmp_device = FactoryGirl.build(:device, user_id: user.id)
          device = Device.create_session({uuid: tmp_device.uuid, platform: tmp_device.platform, user_id: user.id})
          expect(device.authentication_token.present?).to eq true
        end

        it 'when device exist' do
          device = FactoryGirl.create(:device)
          new_device = Device.create_session({uuid: device.uuid, platform: device.platform, user_id: device.user.id})
          expect(device.id).to eq(new_device.id)
          expect(device.authentication_token).to_not eq(new_device.authentication_token)
        end
      end
    end
  end
end
