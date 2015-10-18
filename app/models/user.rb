class User < ActiveRecord::Base

  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest
  before_save :downcase_email
  # before_save { self.email = email.downcase }
  validates :name, presence: true, 
            length: {maximum: 50} 
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
  validates :email,presence: true,
            length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: { case_sensitive: false } 
  has_secure_password 
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  #associations, dependant
  has_many :microposts, dependent: :destroy

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

  # def authenticated?(remember_token)
  #   return false if remember_digest.nil?
  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end
  def authenticated?(attribute , token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # activate account
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # create reset digest for user
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # send password reset emails 
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # returns true is password reset has expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # micropost feeds
  def feed
    Micropost.where("user_id =?", id)
  end

  private
    def downcase_email
      self.email = email.downcase 
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
  # def create_activation_digest

  # end

end
