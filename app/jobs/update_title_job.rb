class UpdateTitleJob < ApplicationJob
  @queue = :default

  def perform(short_url_id)
    # I can see from Resque.info that resque is porcessing jobs
    # after Rescue.enqueue(UpdateTitleJob, short_url_id) is called
    # but I am not seeing any update to the job title
    # Unsure if this is just a configuration issue or not

    short_url = ShortUrl.find(short_url_id)

    url = URI.parse(short_url.full_url)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port, use_ssl: true) { |http| http.request(req) }

    title = res.body.match("<title>(.*)<\/title>")[1]

    short_url.title = title
    short_url.save!
  end
end
