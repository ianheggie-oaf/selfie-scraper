# It's easy to add more libraries or choose different versions. Any libraries
# specified here will be installed and made available to your morph.io scraper.
# Find out more: https://morph.io/documentation/ruby

source "https://rubygems.org"

ruby "3.3.8"

# Core dependencies
gem "activesupport", "~> 7.0.8" # Reduced for compatibility
gem "mechanize", "~> 2.8.5" # Older version for nokogiri compatibility
gem "nokogiri", "~> 1.15.0" # Compatible version, no platform constraint
gem "sqlite3", "~> 1.6.3" # Older version that works on heroku-18
gem "scraperwiki", git: "https://github.com/openaustralia/scraperwiki-ruby.git",
    branch: "morph_defaults"

# Development and testing dependencies (not used on heroku-18)
group :development, :test do
  gem "mini_magick", "~> 4.12"
  gem "rake", "~> 13.0" # Required update for Ruby 3.2
  gem "rspec", "~> 3.12" # Latest stable
  gem "rubocop", "~> 1.57" # Latest with good Ruby 3.x support
  gem "simplecov", "~> 0.22.0", require: false
  gem "timecop", "~> 0.9"
  gem "vcr", "~> 6.2"
  gem "watir", "~> 7.3" # Latest stable with Selenium 4 support
  gem "webmock", "~> 3.19"
end


