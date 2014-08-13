require 'digest/sha1'

class User < ActiveRecord::Base
  self.table_name = "cms_users"
  self.primary_key = "user_id"

  validates_presence_of :user_name
  validates_uniqueness_of :user_name
  attr_accessor :password_confirmation
  validates_confirmation_of :password

  def validate
    errors.add_to_base("Missing password" ) if user_pass.blank?
  end

  def after_destroy
    if User.count.zero?
      raise "Can't delete last user"
    end
  end

  def self.authenticate(name, password)
    user = self.find_by_user_name(name)
    if user
      expected_password = encrypted_password(password)
      if user.user_pass != expected_password
        user = nil
      end
    end
    user
  end
  
  # 'password' is a virtual attribute
  def password
    @password
  end
  
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    self.user_pass = User.encrypted_password(self.password)
  end
  
  private
  def self.encrypted_password(password)
    string_to_hash = password + "wibble"  # 'wibble' makes it harder to guess
    (Digest::SHA1.hexdigest(string_to_hash))[0,16]
  end

 end