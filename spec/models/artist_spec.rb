RSpec.describe Artist do
  it "requires a name" do
    artist = Artist.new(name: nil)
    expect(artist).not_to be_valid
    expect(artist.errors[:name]).to be_present
  end
end
