class UpdateTitleJob < ApplicationJob
  @queue = :default

  def perform(short_url_id)
    # Do we get this by going to the URL and gettings its title tag?
    short_url = ShortUrl.find(short_url_id)

    url = URI.parse(short_url.full_url)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port, use_ssl: true) { |http| http.request(req) }

    title = res.body.match("<title>(.*)<\/title>")[1]

    short_url.title = title
    short_url.save!
  end
end
