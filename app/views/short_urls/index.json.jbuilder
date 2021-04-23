json.array! @short_urls do |short_url|
  json.full_url short_url.full_url
  json.click_count short_url.click_count
end