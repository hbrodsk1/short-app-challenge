class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validates :full_url, :short_code, uniqueness: true, on: :create
  validates :full_url, presence: true
  #validate :validate_full_url, on: :create
  validates :full_url, format: { with: /\A(http|https):\/\/*(www.)*([a-zA-Z0-9])+.([a-zA-Z0-9]){2,}/,
    message: "is not a valid url"}


  def self.short_code
    number_of_records = ShortUrl.count
    number_of_potential_characters = CHARACTERS.count

    if number_of_records == 0
      short_code_length = 1
    elsif number_of_records % number_of_potential_characters == 0
      short_code_length = (number_of_records / number_of_potential_characters)
    else
      short_code_length = (number_of_records / number_of_potential_characters) + 1
    end

    short_code_chars = CHARACTERS.sample(short_code_length).join
  end

  def update_title!
    # This is the same work being done in the UpdateTitleJob worker
    # I'm unsure if this method should have some sort of different functionality

    url = URI.parse(self.full_url)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port, use_ssl: true) { |http| http.request(req) }

    title = res.body.match("<title>(.*)<\/title>")[1]

    self.title = title
    self.save!
  end

  private

  def validate_full_url
    # Opted to use a built in rails validation, instead of a custom. See validations above
    unless self.full_url.match?(/\A(http|https):\/\/*(www.)*([a-zA-Z0-9])+.([a-zA-Z0-9]){2,}/)
      errors.add(:validation, "is not a valid url")
    end
  end

end
