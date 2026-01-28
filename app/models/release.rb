class Release < ApplicationRecord
  has_one :album, dependent: :destroy
  has_many :artist_releases, dependent: :destroy
  has_many :artists, through: :artist_releases

  validates :name, :released_at, presence: true
end
