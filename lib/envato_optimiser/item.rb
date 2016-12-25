require 'net/http'
require 'uri'
require 'nokogiri'

module EnvatoOptimiser
  class Item
    # Initialize a new item page.
    #
    # @return [Nothing]
    def initialize(item_url)
      uri         = URI.parse(item_url)
      response    = Net::HTTP.get_response(uri)
      @document   = Nokogiri::HTML(response.body)
      @image_urls = image_urls
    end

    # Run checks against a specific item page.
    #
    # @param skip_image_status_check [Boolean] Used for determining whether or
    #   not the image HTTP response status checks should be run.
    #
    # @return [Hash] Consolidated list of the checks output.
    def check!(skip_image_status_check: false)
      reports = []

      reports << EnvatoOptimiser::ImageResponseStatusCodeCheck.new(@image_urls).to_h unless skip_image_status_check

      reports.inject(&:merge)
    end

    private

    # Gather all the image URLs.
    #
    # Loops over the document output and collects all of the image source values
    #   within the defined CSS div where user input is declared.
    #
    # @return [Array] All the images found in the requested document.
    def image_urls
      images = []

      @document.css('.user-html img').map do |image|
        images << image.attributes['src'].value
      end

      # Don't choke on protocol relative URL's.
      images.collect { |image| image.gsub(%r{^//}, 'https://') }
    end
  end
end
