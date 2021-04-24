class AddShortUrlToShortUrls < ActiveRecord::Migration[6.0]
  def change
    add_column :short_urls, :short_url, :string
  end
end
