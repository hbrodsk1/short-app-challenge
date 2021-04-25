class RenameShortUrlToShorty < ActiveRecord::Migration[6.0]
  def change
    rename_column :short_urls, :short_url, :shorty
  end
end
