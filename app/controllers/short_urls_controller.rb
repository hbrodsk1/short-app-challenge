class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    @short_urls = ShortUrl.order(click_count: :desc)

    render json: { urls: @short_urls }, status: 200
  end

  def create
    full_url = params[:full_url]

    @short_url = ShortUrl.create_or_find_by(full_url: full_url)


    if @short_url
      render json: { short_code: @short_url.short_code }, status: 200
    else
      render json: 'No work'
    end
  end

  def show
    @short_url = ShortUrl.find(params[:full_url])

    @short_url.click_count += 1
  end
end
