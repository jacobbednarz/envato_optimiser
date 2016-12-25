module EnvatoOptimiser
  class ImageResponseStatusCodeCheck < Checks
    # Initialize an image response status code check.
    #
    # @param image_urls [Array] Image URLs that you would like to check the HTTP
    #   response status codes for.
    #
    # @return [Nothing].
    def initialize(image_urls)
      @redirects    = []
      @not_found    = []
      @forbidden    = []
      @server_error = []

      fetch_image_responses(image_urls)
    end

    # Format the image response status code results into a usable Hash.
    #
    # @return [Hash]
    def to_h
      {
        :image_redirect_count     => redirect_count,
        :image_not_found_count    => not_found_count,
        :image_forbidden_count    => forbidden_count,
        :image_server_error_count => server_error_count,
      }
    end

    private

    def redirect_count
      @redirects.size
    end

    def not_found_count
      @not_found.size
    end

    def forbidden_count
      @forbidden.size
    end

    def server_error_count
      @server_error.size
    end

    def fetch_image_responses(image_urls)
      image_urls.each do |image|
        response = Net::HTTP.get_response(URI.parse(image))

        case response.code.to_i
        when 300..399
          @redirects << image
        when 404
          @not_found << image
        when 403
          @forbidden << image
        when 500..599
          @server_error << image
        end
      end
    end
  end
end
