FactoryBot.define do
  factory :album do
    name { Faker::Music.album }
    duration_in_minutes { 47 }
    artist { create(:artist) }
    release { create(:release_without_album) }
  end
end
