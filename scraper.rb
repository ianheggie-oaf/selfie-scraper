# frozen_string_literal: true

# This is a template for a Ruby scraper on morph.io (https://morph.io)
# including some code snippets below that you should find helpful

require 'bundler/setup'

def check_gem(name)
  puts "Checking #{name} gem..."
  begin
    yield
    puts "✓ #{name} gem is working properly"
    true
  rescue StandardError => e
    puts "✗ #{name} gem failed: #{e.message}"
    puts e.backtrace[0..5].join("\n")
    false
  end
end

puts '=' * 60
puts 'RUBY ENVIRONMENT INFO'
puts "Ruby version: #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
puts "RubyGems version: #{Gem::VERSION}"
puts "Bundler version: #{Bundler::VERSION}" if defined?(Bundler)

puts "\n#{'=' * 60}"
puts 'CHECKING CORE GEMS'

all_gems_ok = true

all_gems_ok &= check_gem('Nokogiri') do
  require 'nokogiri'
  version = Nokogiri::VERSION
  puts "  Version: #{version}"
  html = Nokogiri::HTML('<p>Test paragraph</p>')
  text = html.at_css('p').text
  raise "Unexpected text: #{text}" unless text == 'Test paragraph'
end

all_gems_ok &= check_gem('Mechanize') do
  require 'mechanize'
  version = Mechanize::VERSION
  puts "  Version: #{version}"
  agent = Mechanize.new
  agent.user_agent = 'Selfie Scraper'
  # # Read in a page
  agent.get('http://example.com')
  # TODO: - check we can get the contents of page
end

all_gems_ok &= check_gem('ActiveSupport') do
  require 'active_support'
  require 'active_support/core_ext'
  version = ActiveSupport::VERSION::STRING
  puts "  Version: #{version}"
  time = 1.day.ago
  puts "  Sample: 1 day ago = #{time}"
  raise 'Unexpected time calculation' unless time < Time.now
end

all_gems_ok &= check_gem('SQLite3') do
  require 'sqlite3'
  version = SQLite3::VERSION
  puts "  Version: #{version}"
  # Create a temporary in-memory database
  db = SQLite3::Database.new ':memory:'
  db.execute('CREATE TABLE test (id INTEGER PRIMARY KEY, name TEXT)')
  db.execute('INSERT INTO test (name) VALUES (?)', 'Test Record')
  result = db.execute('SELECT * FROM test').first
  raise "Unexpected result: #{result.inspect}" unless result[1] == 'Test Record'

  db.close
end

all_gems_ok &= check_gem('ScraperWiki') do
  require 'scraperwiki'
  # Simple test of ScraperWiki functionality
  ScraperWiki.save_sqlite(['name'], { 'name' => Time.now.to_s, 'status' => 'it ran' })
  result = ScraperWiki.select("name FROM data WHERE status='it ran'")
  raise 'Failed to retrieve test record' if result.empty?

  puts '  Successfully saved and retrieved a record'
end

IGNORE_LISTS = {
  'ruby-audit' => '-i CVE-2024-27282',
  'bundler-audit' => '-i GHSA-mrxw-mxhj-p664 GHSA-vvfq-8hwr-qm4m GHSA-5w6v-399v-w3cc'
}.freeze

# Security audit checks
def run_security_audit(command)
  puts "\n#{'=' * 60}"
  puts "RUNNING #{command.upcase} with #{IGNORE_LISTS[command]}"

  system("#{command} #{IGNORE_LISTS[command]}")
end

puts "\n#{'=' * 60}",
     'CHECKING SECURITY VULNERABILITIES'

ruby_audit_ok = run_security_audit('ruby-audit')

bundler_audit_ok = run_security_audit('bundler-audit')

if ruby_audit_ok && bundler_audit_ok
  puts "\n✓ SECURITY AUDIT SUCCESSFUL - No unexpected vulnerabilities"
else
  puts "\n✗ SECURITY AUDIT WARNING - Vulnerability changes detected (see above)"
  puts 'Review the differences and update expected files if these vulnerabilities are understood'
end

# Add this to the final all_gems_ok check
all_gems_ok &= ruby_audit_ok && bundler_audit_ok

puts "\n#{'=' * 60}"
if all_gems_ok
  puts '✓ ALL GEMS VERIFIED SUCCESSFULLY'
else
  puts '✗ SOME GEMS FAILED VERIFICATION - CHECK LOGS FOR DETAILS'
end

puts '=' * 60,
     'ENV'
system 'env'

puts '=' * 60,
     'ID'
system 'id'

puts '=' * 60,
     'PWD'
system 'pwd'

puts '=' * 60,
     'UPTIME'
system 'uptime'

puts '=' * 60,
     'FREE MEMORY'
system 'free -m'

puts '=' * 60,
     'DISK FREE'
system 'df -m'

puts '=' * 60,
     'uname -a'
system 'uname -a 2>&1'

puts '=' * 60,
  "Project Directory Listing"
system 'ls -la'

puts '=' * 60,
  ".git Directory Listing"
system 'ls -la .git 2>&1'

puts '=' * 60,
  "OS release
system 'cat /etc/os-release 2>&1'

#
# [
# './.bundle/config',
# './Procfile',
# './.profile.d/00_config_vars.sh',
# './.profile.d/ruby.sh',
# './.profile.d/WEB_CONCURRENCY.sh',
# './.release',
# './time.output',
# './tmp/heroku-buildpack-release-step.yml'
# ].each do |file|
#   puts '=' * 60,
#     file
#   system "cat -v '#{file}'"
# end

puts '=' * 60,
     'nproc; nproc --all'
system 'nproc; nproc --all'

puts '=' * 60,
     'tail cpuinfo'
system 'tail -40 /proc/cpuinfo'

require 'etc'

puts "Ruby version: #{RUBY_VERSION}"
puts "CPU cores: #{Etc.nprocessors}"
puts "Available memory: #{`cat /proc/meminfo | grep MemAvailable`}"
puts "Dyno type: #{ENV['DYNO'] || 'unknown'}"

# require 'net/http'
#
# def test_thread_count(count)
#   memory_before = `ps -o rss= -p #{Process.pid}`.to_i
#
#   before = Time.now
#   threads = count.times.map do |i|
#     Thread.new do
#       # Simulate your HTTP request workload
#       Net::HTTP.get(URI("https://example.com"))
#       sleep 0.1 # Simulate some processing
#     end
#   end
#   threads.each(&:join)
#
#   after = Time.now
#   memory_after = `ps -o rss= -p #{Process.pid}`.to_i
#   memory_used = memory_after - memory_before
#
#   puts "Threads: #{count}, Time: #{(after - before).round(3)}s, Memory: #{memory_used}KB"
# end
#
# [1, 5, 10, 20, 30, 50, 75, 100].each do |count|
#   puts '=' * 60, "Testing thread count: #{count} x {get example.com and sleepo 0.1} ..."
#   test_thread_count(count)
# end

puts '=' * 60,
     'UPTIME'
system 'uptime'

puts '=' * 60,
     'FREE MEMORY'
system 'free -m'

puts '=' * 60,
     'PACKAGES'
system 'dpkg -l'

puts '=' * 60,
     "That's All Folks!"

exit all_gems_ok ? 0 : 1

# You don't have to do things with the Mechanize or ScraperWiki libraries.
# You can use whatever gems you want: https://morph.io/documentation/ruby
# All that matters is that your final data is written to an SQLite database
# called "data.sqlite" in the current working directory which has at least a table
# called "data".
