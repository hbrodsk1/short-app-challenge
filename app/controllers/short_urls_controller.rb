class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    @short_urls = ShortUrl.order(click_count: :desc)

    render json: { urls: @short_urls }, status: 200
  end

  def create
    full_url = params[:full_url]
    short_code = ShortUrl.short_code
    @short_url = ShortUrl.new(full_url: full_url, short_code: short_code)

    if @short_url.save
      Resque.enqueue(UpdateTitleJob, @short_url.id)

      render json: { short_code: @short_url.short_code }, status: 200
    else
      render json: { errors: "Full url is not a valid url" }, status: 400
    end
  end

  def show
    @short_url = ShortUrl.find(params[:id])
    @short_url.increment!(:click_count)

    redirect_to @short_url.full_url
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.to_s }, status: 404
  end
end
