require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build :user }

  it { expect(user).to be_valid }
  it { expect(user).to have_secure_password }

  describe 'accotiations' do
    it { expect(user).to have_many(:devices).inverse_of(:user).dependent(:delete_all) }
  end

  describe 'validations' do
    it { expect(user).to validate_presence_of(:email) }
    it { expect(user).to validate_uniqueness_of(:email).case_insensitive }
    it { expect(user).to allow_value(Faker::Internet.safe_email).for(:email) }
    it { expect(user).to_not allow_value('qwe@').for(:email) }
    it { expect(user).to_not allow_value('qwe@qwe').for(:email) }
    it { expect(user).to_not allow_value('@qwe').for(:email) }
    it { expect(user).to_not allow_value('qwe.ru').for(:email) }
    it { expect(user).to_not allow_value('qwe@.ru').for(:email) }
    it { expect(user).to_not allow_value('@qwe.qw').for(:email) }
  end
end
