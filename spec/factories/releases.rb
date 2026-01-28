FactoryBot.define do
  factory :release_without_album, class: "Release" do
    name { Faker::Music.album }
    released_at { Faker::Time.between(from: 1.year.ago, to: 1.year.from_now) }
  end

  factory :release do
    name { Faker::Music.album }
    released_at { Faker::Time.between(from: 1.year.ago, to: 1.year.from_now) }

    after(:create) do |release|
      create(:album, release: release)
    end
  end
end
