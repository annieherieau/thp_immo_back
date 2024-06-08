# frozen_string_literal: true

class User < ApplicationRecord # rubocop:todo Style/Documentation
  include Devise::JWT::RevocationStrategies::JTIMatcher
  
  # Include default devise modules. Others available are:
  # :recoverable, :rememberable, :validatable,
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :rememberable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  def send_reset_password_instructions(raw)
    UserMailer.reset_password_instructions(self, raw).deliver_now
  end

  def generate_password_token!
    # raw is token (used in reset email link)
    # hashed is encrypted token (saved in database)
    raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
    self.reset_password_token = hashed
    self.reset_password_sent_at = Time.now.utc
    save!
    raw
  end

  def password_token_valid?
    (self.reset_password_sent_at + 6.hours) > Time.now.utc
  end
  
  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

end
