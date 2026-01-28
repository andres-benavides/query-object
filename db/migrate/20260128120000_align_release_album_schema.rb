class AlignReleaseAlbumSchema < ActiveRecord::Migration[7.0]
  def change
    add_index :releases, :released_at
    add_index :artist_releases, [:artist_id, :release_id], unique: true
  end
end
