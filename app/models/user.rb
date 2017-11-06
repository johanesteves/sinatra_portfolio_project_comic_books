class User < ActiveRecord::Base
  has_secure_password

  has_many :authors
  has_many :comicbooks
  has_many :issues
end