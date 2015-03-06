class User < ActiveRecord::Base
  include User::EmailRegex

  has_secure_password


  # #############################################################
  # Associations

  has_many :devices, inverse_of: :user, dependent: :delete_all


  # #############################################################
  # Validations

  validates :email, presence: true,
                    uniqueness: { :case_sensitive => false },
                    format: { :with => email_regex }

end
