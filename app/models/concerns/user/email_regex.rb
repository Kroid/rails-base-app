# Regex for email from Authlogic
# https://github.com/binarylogic/authlogic/blob/master/lib/authlogic/regex.rb
module User::EmailRegex
  extend ActiveSupport::Concern

  module ClassMethods
    def email_regex
      return @email_regex if defined?(@email_regex)

      email_name_regex  = '[A-Z0-9_\.%\+\-\']+'
      domain_head_regex = '(?:[A-Z0-9\-]+\.)+'
      domain_tld_regex  = '(?:[A-Z]{2,13})'
      @email_regex = /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i
    end
  end
end
