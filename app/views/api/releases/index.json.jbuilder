json.data @releases do |release|
  json.type "releases"
  json.id release.id.to_s

  json.attributes do
    json.name release.name
    json.released_at release.released_at
  end

  json.relationships do
    json.album do
      json.data do
        json.type "albums"
        json.id release.album.id.to_s
      end
    end

    json.artists do
      json.data release.artists do |artist|
        json.type "artists"
        json.id artist.id.to_s
      end
    end
  end
end

albums = @releases.map(&:album).compact.uniq
artists = @releases.flat_map(&:artists).uniq
included = albums + artists

json.included do
  json.array! included do |record|
    case record
    when Album
      json.type "albums"
      json.id record.id.to_s
      json.attributes do
        json.name record.name
      end
    when Artist
      json.type "artists"
      json.id record.id.to_s
      json.attributes do
        json.name record.name
      end
    end
  end
end

json.meta do
  json.page @meta[:page]
  json.per_page @meta[:per_page]
  json.total_pages @meta[:total_pages]
  json.total_count @meta[:total_count]
end
