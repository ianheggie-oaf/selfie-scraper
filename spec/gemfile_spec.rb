# frozen_string_literal: true

require 'spec_helper'
require 'mini_magick'
require 'json'
require 'timecop'
require 'vcr'
require 'webmock'
require 'watir'
require 'simplecov'

RSpec.describe 'Development Gem Verification' do
  context 'JSON gem' do
    it 'correctly parses and generates JSON' do
      data = { name: 'test', value: 123, nested: { key: 'value' } }
      json_string = JSON.generate(data)
      expect(json_string).to include('"name":"test"')

      parsed = JSON.parse(json_string, symbolize_names: true)
      expect(parsed).to eq(data)
    end

    it 'reports its version' do
      expect(JSON::VERSION).to eq('2.10.2')
    end
  end

  context 'MiniMagick gem' do
    it 'reports its version' do
      expect(MiniMagick::VERSION).not_to be_nil
    end

    it 'can create a blank image' do
      image = MiniMagick::Image.create do |f|
        f.write('some content')
      end
      expect(File.exist?(image.path)).to be true
      expect(File.size(image.path)).to be > 0
    ensure
      image&.destroy!
    end
  end

  context 'Timecop gem' do
    it 'freezes time' do
      fixed_time = Time.utc(2023, 1, 1, 12, 0, 0)

      Timecop.freeze(fixed_time) do
        expect(Time.now.utc.to_i).to eq(fixed_time.to_i)
      end

      expect(Time.now.utc.to_i).not_to eq(fixed_time.to_i)
    end
  end

  context 'VCR gem' do
    it 'sets up VCR configuration' do
      VCR.configure do |config|
        config.cassette_library_dir = 'fixtures/vcr_cassettes'
        config.hook_into :webmock
      end

      expect(VCR.configuration.cassette_library_dir).to end_with('selfie-scraper/fixtures/vcr_cassettes')
    end
  end

  context 'WebMock gem' do
    it 'stubs HTTP requests' do
      stub = WebMock.stub_request(:get, 'https://example.com')
                    .to_return(status: 200, body: 'Hello World')

      response = Net::HTTP.get(URI('https://example.com'))
      expect(response).to eq('Hello World')
      expect(stub).to have_been_requested
    end
  end

  # Watir requires a browser driver, which might not be available in all environments
  # Instead, we'll just test that it loads properly
  context 'Watir gem' do
    it 'loads successfully' do
      expect(Watir::VERSION).not_to be_nil
      expect(defined?(Watir::Browser)).to eq('constant')
    end
  end

  context 'SimpleCov gem' do
    it 'loads successfully' do
      expect(SimpleCov::VERSION).not_to be_nil
    end
  end

  # Ruby-audit and bundler-audit are primarily command-line tools
  # We'll just check they can be required
  context 'Security audit gems' do
    it 'loads ruby_audit' do
      require 'ruby_audit'
      expect(defined?(RubyAudit)).to eq('constant')
    end

    it 'loads bundler-audit' do
      require 'bundler/audit'
      expect(defined?(Bundler::Audit)).to eq('constant')
    end
  end
end
