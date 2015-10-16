class User < ActiveRecord::Base

  attr_accessor :remember_token

  before_save { self.email = email.downcase }
  validates :name, presence: true, 
            length: {maximum: 50} 
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
  validates :email,presence: true,
            length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: { case_sensitive: false } 
  has_secure_password 
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  #generate a password for testing 
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # generate a random string to be saved as token 
  def self.new_token
    SecureRandom.urlsafe_base64   
  end 
  # save the the new random string as a token

  #1.create a random string of digits for use as remembe rtoken 
  #2.place the token in the cookies with expiration date 
  #3.save the hash digest of the token to database 
  #4.place encrypted version of user id in browser cookies
  # to make sure of security
  #5. when presented with cookie containing persisten user id ,
  # find th database using given id, verify 
  # remember token matches hash digest from database 
  def remember 
    self.remember_token = User.new_token
    # i dont understand this 
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

end
