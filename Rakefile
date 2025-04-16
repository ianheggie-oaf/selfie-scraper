# frozen_string_literal: true

require 'English'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

namespace :audit do
  desc 'Check the Gemfile.lock for insecure dependencies (updates the database)'
  task :bundle do
    puts 'Checking gem versions ...'
    case system('bundler-audit', 'check')
    when false
      exit $CHILD_STATUS.exitstatus || 1
    when nil
      raise(CommandNotFound, 'bundler-audit could not be executed')
    else
      return true
    end
  end

  desc 'Check the ruby version for security issues (updates the database)'
  task :ruby do
    system('ruby-audit', 'check') || exit(1)
  end
end

desc 'Run security audits'
task audit: %w[audit:bundle audit:ruby] do
  puts 'Security OK!'
end

desc 'Rub scraper, which verifies scraper gems'
task :scraper do
  ruby 'scraper.rb'
end

desc 'Run all verification tasks except audits which are included in scraper'
task verify: %i[scraper spec] do
  puts "\nAll verification tasks completed!"
end

task default: :verify
