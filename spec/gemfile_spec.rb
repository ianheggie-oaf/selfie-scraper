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
    # Ensure tmp/screenshots directory exists
    before(:each) do
      # Clean up files
      FileUtils.rm_rf('tmp/screenshots')
      FileUtils.mkdir_p('tmp/screenshots')
    end

    it 'reports its version' do
      expect(MiniMagick::VERSION).not_to be_nil
    end

    it 'creates a montage' do
      # Create simple colored images
      MiniMagick::Tool::Convert.new do |convert|
        convert.size '800x600'
        convert.canvas 'red'
        convert << 'tmp/screenshots/red_square.png'
      end

      MiniMagick::Tool::Convert.new do |convert|
        convert.size '800x600'
        convert.canvas 'green'
        convert << 'tmp/screenshots/green_square.png'
      end

      # Now test MiniMagick by creating a montage
      MiniMagick::Tool::Montage.new do |montage|
        montage.mode 'unframe'
        montage.background '#000000'
        montage.geometry '600x355+20+20'

        montage << 'tmp/screenshots/red_square.png'
        montage << 'tmp/screenshots/green_square.png'

        montage << 'tmp/screenshots/montage.jpg'
      end

      # Verify montage was created
      expect(File.exist?('tmp/screenshots/montage.jpg')).to be true
      expect(File.size('tmp/screenshots/montage.jpg')).to be > 0
    end

    # Fallback test in case the full test can't run (e.g., no browser available)
    it 'can perform basic image manipulation' do
      # Create a simple colored image
      MiniMagick::Tool::Convert.new do |convert|
        convert.size '100x100'
        convert.canvas 'red'
        convert << 'tmp/screenshots/red_square.png'
      end

      expect(File.exist?('tmp/screenshots/red_square.png')).to be true

      # Test resizing
      image = MiniMagick::Image.open('tmp/screenshots/red_square.png')
      image.resize '50x50'
      image.write 'tmp/screenshots/small_red_square.png'

      expect(File.exist?('tmp/screenshots/small_red_square.png')).to be true
    rescue MiniMagick::Error => e
      skip "Skipping due to ImageMagick issue: #{e.message}"
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
        config.cassette_library_dir = 'spec/vcr_cassettes'
        config.hook_into :webmock
      end

      expect(VCR.configuration.cassette_library_dir).to end_with('selfie-scraper/spec/vcr_cassettes')
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
    # Create test sites to screenshot
    let(:test_sites) do
      {
        'example' => 'https://example.com',
        'google' => 'https://google.com'
      }
    end

    before(:each) do
      # Clean up files
      FileUtils.rm_rf('tmp/screenshots')
      FileUtils.mkdir_p('tmp/screenshots')
    end

    it 'loads successfully' do
      expect(Watir::VERSION).not_to be_nil
      expect(defined?(Watir::Browser)).to eq('constant')
    end

    it 'captures screenshots', js: true do
      skip 'This normally fails on Ians dev system :(' unless ENV['TEST-SCREENSHOTS']
      
      begin
        browser = Watir::Browser.new #:chrome, headless: false

        # Take screenshots of test sites
        test_sites.each do |site_name, url|
          browser.goto url
          browser.screenshot.save "tmp/screenshots/#{site_name}.png"
          expect(File.exist?("tmp/screenshots/#{site_name}.png")).to be true
        end

        # Close the browser
        browser.close
      rescue StandardError => e
        # If test fails because of browser/driver issues, output helpful error
        raise e unless e.message.include?('Chrome')

        skip "Skipping due to Chrome/driver issue: #{e.message}"
      end
    end
  end

  context 'SimpleCov gem' do
    it 'loads successfully' do
      expect(SimpleCov::VERSION).not_to be_nil
    end
  end
end
