# == Schema Information
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  login               :string(255)
#  email               :string(255)
#  first_name          :string(255)
#  last_name           :string(255)
#  crypted_password    :string(255)
#  password_salt       :string(255)
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  login_count         :integer         default(0), not null
#  failed_login_count  :integer         default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  terms_of_service    :boolean         not null
#  time_zone           :string(255)     default("UTC")
#  disabled_at         :datetime
#  created_at          :datetime
#  activated_at        :datetime
#  updated_at          :datetime
#  identity_url        :string(255)
#  url_key             :string(255)
#

class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  include MuckUsers::Models::MuckUser
  include MuckActivities::Models::MuckActivityConsumer
  include MuckContents::Models::MuckContentable
  
  def can_add_root_content?
    admin?
  end
  
  def can_upload?(check_user)
    true
  end
  
end
