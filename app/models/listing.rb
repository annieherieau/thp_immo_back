class Listing < ApplicationRecord
  belongs_to :city
  belongs_to :user
  has_one_attached :photo

  def photo_url
    Rails.application.routes.url_helpers.rails_blob_url(photo, only_path: true) if photo.attached?
  end
end
