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
ScraperWiki.save_sqlite(["name"], {"name" => Time.now.to_s, "status" => "it ran"})

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

[
'./.bundle/config',
'./Procfile',
'./.profile.d/00_config_vars.sh',
'./.profile.d/ruby.sh',
'./.profile.d/WEB_CONCURRENCY.sh',
'./.release',
'./time.output',
'./tmp/heroku-buildpack-release-step.yml'
].each do |file|
  puts '=' * 60,
    file
  system "cat -v '#{file}'"
end

puts '=' * 60,
  "nproc; nproc --all"
system 'nproc; nproc --all'

puts '=' * 60,
  "cpuinfo"
system 'cat /proc/cpuinfo'

require 'etc'

puts "Ruby version: #{RUBY_VERSION}"
puts "CPU cores: #{Etc.nprocessors}"
puts "Available memory: #{`cat /proc/meminfo | grep MemAvailable`}"
puts "Dyno type: #{ENV['DYNO'] || 'unknown'}"

require 'net/http'

def test_thread_count(count)
  memory_before = `ps -o rss= -p #{Process.pid}`.to_i
  
  before = Time.now
  threads = count.times.map do |i|
    Thread.new do
      # Simulate your HTTP request workload
      Net::HTTP.get(URI("https://example.com"))
      sleep 0.1 # Simulate some processing
    end
  end
  threads.each(&:join)
  
  after = Time.now
  memory_after = `ps -o rss= -p #{Process.pid}`.to_i
  memory_used = memory_after - memory_before
  
  puts "Threads: #{count}, Time: #{(after - before).round(3)}s, Memory: #{memory_used}KB"
end

[1, 5, 10, 20, 30, 50, 75, 100].each do |count|
  puts '=' * 60, "Testing thread count: #{count} x {get example.com and sleepo 0.1} ..."
  test_thread_count(count)
end

puts '=' * 60,
  "UPTIME"
system 'uptime'

puts '=' * 60,
  "FREE MEMORY"
system 'free -m'

puts '=' * 60,
  "type parallel ; parallel --version ; parallel --help"
system 'type parallel ; parallel --version ; parallel --help'

puts '=' * 60,
  "That's All Folks!"

# You don't have to do things with the Mechanize or ScraperWiki libraries.
# You can use whatever gems you want: https://morph.io/documentation/ruby
# All that matters is that your final data is written to an SQLite database
# called "data.sqlite" in the current working directory which has at least a table
# called "data".
