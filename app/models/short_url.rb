class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validates :full_url, uniqueness: true, on: :create
  validates :full_url, presence: true
  #validate :validate_full_url, on: :create
  validates :full_url, format: { with: /\A(http|https):\/\/*(www.)*([a-zA-Z0-9])+.([a-zA-Z0-9]){2,}/,
    message: "is not a valid url"}


  def self.short_code
    short_code_length = ShortUrl.count.digits.length
    short_code_chars = CHARACTERS.sample(short_code_length).join
  end

  def update_title!
    # Do we get this by going to the URL and gettings its title tag?

    url = URI.parse(self.full_url)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port, use_ssl: true) { |http| http.request(req) }

    title = res.body.match("<title>(.*)<\/title>")[1]

    self.title = title
    self.save!
  end

  private

  def validate_full_url
    unless self.full_url.match?(/\A(http|https):\/\/*(www.)*([a-zA-Z0-9])+.([a-zA-Z0-9]){2,}/)
      errors.add(:validation, "Full url is not a valid url")
    end
  end

end
