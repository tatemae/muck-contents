class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  acts_as_muck_user
  has_activities
  
  def can_add_root_content?
    admin?
  end
  
end