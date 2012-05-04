class User < ActiveRecord::Base

  attr_accessible :password_digest

  has_secure_password

end
