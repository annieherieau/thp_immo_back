# frozen_string_literal: true

class User < ApplicationRecord # rubocop:todo Style/Documentation
  include Devise::JWT::RevocationStrategies::JTIMatcher
  
  # Include default devise modules. Others available are:
  # :recoverable, :rememberable, :validatable,
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :rememberable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  def send_reset_password_instructions(token)
    UserMailer.reset_password_instructions(self, token).deliver_now
  end

  def generate_password_token!
    token, hashed_token = Devise.token_generator.generate(User, :reset_password_token)
    self.reset_password_token = hashed_token
    self.reset_password_sent_at = Time.now.utc
    save!
    return token
  end
  
  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end
  
  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

end
