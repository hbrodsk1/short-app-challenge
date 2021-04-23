class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validates :full_url, uniqueness: true, on: :create
  validate :validate_full_url

  def short_code
    short_code_length = ShortUrl.count.digits.length
    short_code_chars = CHARACTERS.sample(short_code_length).join

    "https://www.shoco.com/#{short_code_chars}"
  end

  def update_title!
    # Do we get this by going to the URL and gettings its title tag?
  end

  private

  def validate_full_url
    true
    # Create regex to match valid URLs
  end

end
