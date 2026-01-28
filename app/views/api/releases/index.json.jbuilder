json.data @releases do |release|
  json.id release.id
  json.name release.name
  json.released_at release.released_at

  json.album do
    json.id release.album.id
    json.name release.album.name
  end

  json.artists release.artists do |artist|
    json.id artist.id
    json.name artist.name
  end
end

json.meta do
  json.page @meta[:page]
  json.per_page @meta[:per_page]
  json.total_pages @meta[:total_pages]
  json.total_count @meta[:total_count]
end
