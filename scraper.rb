# This is a template for a Ruby scraper on morph.io (https://morph.io)
# including some code snippets below that you should find helpful

require 'scraperwiki'
require 'mechanize'
#
agent = Mechanize.new
#
# # Read in a page
page = agent.get("http://example.com")
#
# # Find something on the page using css selectors
# p page.at('div.content')
#
# # Write out to the sqlite database using scraperwiki library
ScraperWiki.save_sqlite(["name"], {"name" => "example", "status" => "it worked"})

puts '=' * 60,
  "ENV"
system 'env'

puts '=' * 60,
  "ID"
system 'id'

puts '=' * 60,
  "PWD"
system 'pwd'

puts '=' * 60,
  "UPTIME"
system 'uptime'

puts '=' * 60,
  "FREE MEMORY"
system 'free -m'

puts '=' * 60,
  "DISK FREE"
system 'df -m'

puts '=' * 60,
  "Files and Dirs"
system 'find | xargs ls -ld'

puts '=' * 60,
  "That's All Folks!"
#
# # An arbitrary query against the database
# ScraperWiki.select("* from data where 'name'='peter'")

# You don't have to do things with the Mechanize or ScraperWiki libraries.
# You can use whatever gems you want: https://morph.io/documentation/ruby
# All that matters is that your final data is written to an SQLite database
# called "data.sqlite" in the current working directory which has at least a table
# called "data".
