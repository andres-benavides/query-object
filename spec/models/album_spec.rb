RSpec.describe Album do
  it "requires a name" do
    album = Album.new(name: nil)
    expect(album).not_to be_valid
    expect(album.errors[:name]).to be_present
  end
end
