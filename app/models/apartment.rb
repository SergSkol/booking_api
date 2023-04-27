class Item < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_many :users, through: :reservations

  validates :name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :description, presence: true
  validate :validate_photo_url
  validates :location, presence: true, length: { minimum: 2, maximum: 30 }
  validates :price, presence: true, numericality: { greater_than: 0 }

  private

  def validate_photo_url
    return unless photo

    unless URI.parse(photo).is_a?(URI::HTTP) || URI.parse(photo).is_a?(URI::HTTPS)
      errors.add(:photo, 'must be a valid URL format')
    end
  rescue URI::InvalidURIError
    errors.add(:photo, 'must be a valid URL format')
  end
end
