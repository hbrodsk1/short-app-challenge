class RenameShortyToShortCode < ActiveRecord::Migration[6.0]
  def change
    rename_column :short_urls, :shorty, :short_code
  end
end
