class ReleasesQuery
  def initialize(relation: Release.includes(:album, :artists), filter: nil)
    @relation = relation
    @filter = filter
  end

  def call
    case @filter
    when "past"
      @relation.where("released_at < ?", Date.current).order(released_at: :desc)
    when "upcoming"
      @relation.where("released_at >= ?", Date.current).order(released_at: :asc)
    else
      @relation.order(released_at: :desc)
    end
  end
end
