RSpec.describe Release do
  it "requires name and released_at" do
    release = Release.new(name: nil, released_at: nil)
    expect(release).not_to be_valid
    expect(release.errors[:name]).to be_present
    expect(release.errors[:released_at]).to be_present
  end
end
