# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base # rubocop:todo Style/Documentation
  default from: ENV['MAILJET_DEFAULT_FROM']
  layout 'mailer'

  def application_url
    if Rails.env.production?
      ENV['PROD_HOST']
    else
      ENV['DEV_HOST']
    end
  end
end
