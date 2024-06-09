class City < ApplicationRecord
  has_many :listings, dependent: :destroy
end
