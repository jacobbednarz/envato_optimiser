module EnvatoOptimiser
  class ImageCheck < Check
    attr_reader :response,
                :document

    def initialize(item_url)
      uri              = URI.parse(item_url)
      @response        = Net::HTTP.get_response(uri)
      @document        = Nokogiri::HTML(response.body)
      @image_404s      = []
      @image_403s      = []
      @image_redirects = []
      @image_weight    = 0
    end

    def run!
      image_response_check
      to_h
    end

    private

    # Internal: Return a Hash of the image checks.
    #
    # Returns a Hash with the following keys:
    #
    #   - image_count: Total number of images requested.
    #   - image_403_count: Number of HTTP 403's encountered.
    #   - image_404_count: Number of HTTP 404's encountered.
    #   - image_redirect_count: Number of HTTP redirects encountered.
    #   - total_image_weight: Size in bytes of all HTTP image requests made.
    def to_h
      {
        :image_count          => image_count,
        :image_403_count      => image_403_count,
        :image_404_count      => image_404_count,
        :image_redirect_count => image_redirect_count,
        :total_image_weight   => total_image_weight
      }
    end
    alias_method :to_hash, :to_h

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

    def total_image_weight
      @image_weight
    end

    def image_response_check
      images.each do |image|
        response = Net::HTTP.get_response(URI.parse(image))
        @image_weight += response.content_length

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

      document.css('.user-html img').map do |image|
        images << image.attributes['src'].value
      end

      # Don't choke on protocol relative URL's.
      images.collect { |image| image.gsub(%r{^//}, 'https://') }
    end
  end
end
