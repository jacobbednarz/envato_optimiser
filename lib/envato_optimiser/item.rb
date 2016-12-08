require 'net/http'
require 'uri'
require 'nokogiri'

module EnvatoOptimiser
  class Item
    attr_reader :uri,
                :response,
                :document


    def initialize(url)
      @uri      = URI.parse(url)
      @response = Net::HTTP.get_response(uri)
      @document = Nokogiri::HTML(response.body)
    end

    def user_image_count
      user_images.size
    end

    private

    def user_images
      images = []

      @document.css('.user-html img').map do |image|
        images << image.attributes['src'].value
      end

      images
    end
  end
end
