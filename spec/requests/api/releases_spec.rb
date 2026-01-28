require "rails_helper"

RSpec.describe "Api::Releases", type: :request do
  describe "GET /api/releases" do
    let(:headers) { { "ACCEPT" => "application/json" } }

    it "returns 200 and data/meta structure" do
      release = create(:release, released_at: Date.current)
      artist = create(:artist)
      create(:artist_release, release: release, artist: artist)

      get "/api/releases", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to include("data", "meta")
      expect(json["data"]).to be_an(Array)
      expect(json["data"].first).to include("id", "name", "released_at", "album", "artists")
      expect(json["data"].first["album"]).to include("id", "name")
      expect(json["data"].first["artists"]).to be_an(Array)
      expect(json["meta"]).to include("page", "per_page", "total_pages", "total_count")
    end

    it "filters past releases" do
      create(:release, released_at: Date.current + 3.days)
      older_past = create(:release, released_at: Date.current - 5.days)
      newer_past = create(:release, released_at: Date.current - 1.day)

      get "/api/releases", params: { filter: "past" }, headers: headers

      json = JSON.parse(response.body)
      ids = json["data"].map { |item| item["id"] }
      expect(ids).to eq([newer_past.id, older_past.id])
    end

    it "filters upcoming releases" do
      sooner_upcoming = create(:release, released_at: Date.current + 1.day)
      later_upcoming = create(:release, released_at: Date.current + 10.days)
      create(:release, released_at: Date.current - 1.day)

      get "/api/releases", params: { filter: "upcoming" }, headers: headers

      json = JSON.parse(response.body)
      ids = json["data"].map { |item| item["id"] }
      expect(ids).to eq([sooner_upcoming.id, later_upcoming.id])
    end

    it "paginates with default limit" do
      create_list(:release, 15)

      get "/api/releases", headers: headers

      json = JSON.parse(response.body)
      expect(json["data"].length).to eq(10)
      expect(json["meta"]).to include(
        "page" => 1,
        "per_page" => 10,
        "total_pages" => 2,
        "total_count" => 15
      )
    end

    it "paginates with limit and page" do
      create_list(:release, 25)

      get "/api/releases", params: { page: 2, limit: 5 }, headers: headers

      json = JSON.parse(response.body)
      expect(json["data"].length).to eq(5)
      expect(json["meta"]).to include(
        "page" => 2,
        "per_page" => 5,
        "total_pages" => 5,
        "total_count" => 25
      )
    end

    it "orders past releases by released_at desc" do
      newest = create(:release, released_at: 2.days.ago)
      oldest = create(:release, released_at: 10.days.ago)
      create(:release, released_at: 3.days.from_now)

      get "/api/releases", params: { filter: "past" }, headers: headers

      json = JSON.parse(response.body)
      ids = json["data"].map { |item| item["id"] }
      expect(ids).to eq([newest.id, oldest.id])
    end

    it "orders upcoming releases by released_at asc" do
      soonest = create(:release, released_at: 1.day.from_now)
      latest = create(:release, released_at: 10.days.from_now)
      create(:release, released_at: 2.days.ago)

      get "/api/releases", params: { filter: "upcoming" }, headers: headers

      json = JSON.parse(response.body)
      ids = json["data"].map { |item| item["id"] }
      expect(ids).to eq([soonest.id, latest.id])
    end

    it "defaults to released_at desc without filter" do
      newest = create(:release, released_at: 1.day.ago)
      oldest = create(:release, released_at: 5.days.ago)

      get "/api/releases", headers: headers

      json = JSON.parse(response.body)
      ids = json["data"].map { |item| item["id"] }
      expect(ids.first(2)).to eq([newest.id, oldest.id])
    end

    it "treats invalid filter as no filter" do
      newest = create(:release, released_at: 1.day.ago)
      oldest = create(:release, released_at: 5.days.ago)

      get "/api/releases", params: { filter: "invalid" }, headers: headers

      json = JSON.parse(response.body)
      ids = json["data"].map { |item| item["id"] }
      expect(ids.first(2)).to eq([newest.id, oldest.id])
    end

    it "falls back to default pagination on invalid params" do
      create_list(:release, 12)

      get "/api/releases", params: { page: 0, limit: "nope" }, headers: headers

      json = JSON.parse(response.body)
      expect(json["data"].length).to eq(10)
      expect(json["meta"]).to include("page" => 1, "per_page" => 10)
    end

    it "returns empty data for page beyond total" do
      create_list(:release, 3)

      get "/api/releases", params: { page: 5, limit: 2 }, headers: headers

      json = JSON.parse(response.body)
      expect(json["data"]).to eq([])
      expect(json["meta"]).to include("page" => 5, "per_page" => 2, "total_pages" => 2, "total_count" => 3)
    end

    it "returns empty artists array when no artists associated" do
      release = create(:release, released_at: Date.current)

      get "/api/releases", headers: headers

      json = JSON.parse(response.body)
      entry = json["data"].find { |item| item["id"] == release.id }
      expect(entry["artists"]).to eq([])
    end
  end
end
