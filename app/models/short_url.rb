class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validates :full_url, uniqueness: true, on: :create
  validates :full_url, presence: true
  #validate :validate_full_url, on: :create
  validates :full_url, format: { with: /\A(http|https):\/\/*(www.)*([a-zA-Z0-9])+.([a-zA-Z0-9]){2,}/ }


  def self.short_code
    short_code_length = ShortUrl.count.digits.length
    short_code_chars = CHARACTERS.sample(short_code_length).join

    "https://www.shoco.com/#{short_code_chars}"
  end

  def update_title!
    # Do we get this by going to the URL and gettings its title tag?
  end

  private

  def validate_full_url
    unless self.full_url.match?(/\A(http|https):\/\/*(www.)*([a-zA-Z0-9])+.([a-zA-Z0-9]){2,}/)
      errors.add(:validation, "Full url is not a valid url")
    end
  end

end
