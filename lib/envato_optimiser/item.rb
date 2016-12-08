require 'net/http'
require 'uri'
require 'nokogiri'

module EnvatoOptimiser
  class Item
    attr_reader :uri,
                :response,
                :document


    def initialize(url)
      @uri             = URI.parse(url)
      @response        = Net::HTTP.get_response(uri)
      @document        = Nokogiri::HTML(response.body)
      @image_404s      = []
      @image_403s      = []
      @image_redirects = []
    end

    def check!
      image_response_check
      to_h
    end

    def image_count
      images.size
    end

    def image_403_count
      @image_403s.size
    end

    def image_404_count
      @image_404s.size
    end

    def image_redirect_count
      @image_redirects.size
    end

    def to_h
      {
        :image_count          => image_count,
        :image_403_count      => image_403_count,
        :image_404_count      => image_404_count,
        :image_redirect_count => image_redirect_count
      }
    end
    alias_method :to_hash, :to_h

    private

    def image_response_check
      images.each do |image|
        response = Net::HTTP.get_response(URI.parse(image))

        case response.code.to_i
        when 300..399
          @image_redirects << image
        when 404
          @image_404s << image
        when 403
          @image_403s << image
        end
      end
    end

    def images
      images = []

      @document.css('.user-html img').map do |image|
        images << image.attributes['src'].value
      end

      # Don't choke on protocol relative URL's.
      images.collect { |image| image.gsub(%r{^//}, 'https://') }
    end
  end
end
