class Device < ActiveRecord::Base

  PLATFORMS = %w(ios android browser)


  # #############################################################
  # Associations

  belongs_to :user


  # #############################################################
  # Validations

  validates :user,     presence: true
  validates :uuid,     presence: true, uniqueness: true
  validates :platform, presence: true, :inclusion => { :in => PLATFORMS }


  # #############################################################
  # Callbacks

  after_create :update_authentication_token
  after_update :update_authentication_token


  def update_authentication_token
    self.update_column(:authentication_token, generate_authentication_token)
  end


  def self.create_session(uuid:, platform:, user_id:)
    device = Device.find_by(:uuid => uuid)

    if device.present?
      device.update_attributes({platform: platform, user_id: user_id})
    else
      device = Device.create({uuid: uuid, platform: platform, user_id: user_id})
    end

    device
  end


  private

  def generate_authentication_token
    loop do
      token = SecureRandom.urlsafe_base64(nil, false)
      break token unless Device.exists?(:authentication_token => token)
    end
  end
end
