# frozen_string_literal: true

# It's easy to add more libraries or choose different versions. Any libraries
# specified here will be installed and made available to your morph.io scraper.
# Find out more: https://morph.io/documentation/ruby

source 'https://rubygems.org'

ruby '3.2.2'

# Core dependencies
#gem 'activesupport', '~> 7.0.8' # Reduced for compatibility
#gem 'activesupport', '~> 7.1.5.1' # Sec support ends 01 Oct 2025
#gem 'activesupport', '~> 7.2.2.1' # Sec support ends 09 Aug 2026
gem 'activesupport', '~> 8.0.2'
gem 'mechanize', '2.14.0' # January 05, 2025 (143 KB)
# gem 'mechanize', '2.13.0' # January 02, 2025 (143 KB)
# gem 'mechanize', '2.12.2' # October 02, 2024 (143 KB)
# gem 'mechanize', '2.12.1' # August 21, 2024 (143 KB)
# gem 'mechanize', '2.12.0' # July 29, 2024 (142 KB)
# gem 'mechanize', '2.11.0' # July 18, 2024 (142 KB)
# gem 'mechanize', '2.10.1' # June 12, 2024 (141 KB)
# gem 'mechanize', '2.10.0' # January 22, 2024 (141 KB)
# gem 'mechanize', '2.9.2' # January 15, 2024 (141 KB)
# gem 'mechanize', '2.9.1' # April 17, 2023 (141 KB)
# gem 'mechanize', '2.9.0' # April 07, 2023 (140 KB)
# gem 'mechanize', '2.8.5' # June 09, 2022 (140 KB)
# gem 'mechanize', '~> 2.8.5' # Older version for nokogiri compatibility

#gem "nokogiri", "1.18.3" # Fixes GHSA-vvfq-8hwr-qm4m BUT fails to run on morph with
# /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.28' not found
gem "nokogiri", "1.16.5" # Fixes GHSA-r95h-9x8f-r3f7
#gem 'nokogiri', '~> 1.15.0' # Compatible version, no platform constraint

gem 'scraperwiki', git: 'https://github.com/openaustralia/scraperwiki-ruby.git',
                   branch: 'morph_defaults'

# gem 'sqlite3', '~> 2.5.0' # FAILS on heroku-18
gem 'sqlite3', '~> 2.4.1' # OK on heroku-18

gem 'bundler-audit'
gem 'ruby_audit'

# Development and testing dependencies (not used on heroku-18)
group :development, :test do
  gem 'json', '2.10.2' # '>= 2.10.2' - security update
  gem 'mini_magick', '~> 4.12'
  gem 'rake', '~> 13.0' # Required update for Ruby 3.2
  gem 'rspec', '~> 3.12' # Latest stable
  gem 'rubocop', '~> 1.57' # Latest with good Ruby 3.x support
  gem 'simplecov', '~> 0.22.0', require: false
  gem 'timecop', '~> 0.9'
  gem 'vcr', '~> 6.2'
  gem 'watir', '~> 7.3' # Latest stable with Selenium 4 support
  gem 'webmock', '~> 3.19'
end
