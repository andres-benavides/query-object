class Api::ReleasesController < ApplicationController
  def index
    releases = ReleasesQuery.new(filter: params[:filter]).call

    page = positive_integer(params[:page], 1)
    limit = positive_integer(params[:limit], 10)

    @releases = releases.page(page).per(limit)
    @meta = {
      page: @releases.current_page,
      per_page: @releases.limit_value,
      total_pages: @releases.total_pages,
      total_count: @releases.total_count
    }
  end

  private
  def positive_integer(value, fallback)
    return fallback if value.blank?

    parsed = value.to_i
    parsed.positive? ? parsed : fallback
  end
end
