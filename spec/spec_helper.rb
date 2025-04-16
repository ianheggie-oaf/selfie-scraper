# frozen_string_literal: true

# Enable SimpleCov if needed
if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/vendor/'
  end
end

# Load the scraper code - adjust path as needed
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
# Replace with your actual main file if needed
# require 'your_main_file'

# Configure RSpec
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.order = :random
  Kernel.srand config.seed
end

# Configure WebMock
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock

  # Important: Ignore WebDriver/Selenium requests
  config.ignore_localhost = true
  config.ignore_request do |request|
    # Ignore all Selenium/WebDriver requests
    request.uri.include?('127.0.0.1') ||
      request.uri.include?('localhost') ||
      request.uri.include?('/session') ||
      request.uri.include?('/wd/hub')
  end

  # Allow HTTP connections when no cassette is in use
  config.allow_http_connections_when_no_cassette = true

  config.configure_rspec_metadata!
end
