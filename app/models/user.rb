# frozen_string_literal: true

class User < ApplicationRecord # rubocop:todo Style/Documentation
  include Devise::JWT::RevocationStrategies::JTIMatcher
  
  # Include default devise modules. Others available are:
  # :recoverable, :rememberable, :validatable,
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :rememberable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  def send_test_email
    UserMailer.test_email(self).deliver_now
  end
end
