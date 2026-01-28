class AlignReleaseAlbumSchema < ActiveRecord::Migration[7.0]
  def change
    add_reference :releases, :album, foreign_key: true, index: true
    add_index :releases, :released_at
    add_index :artist_releases, [:artist_id, :release_id], unique: true
  end
end
