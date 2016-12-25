module EnvatoOptimiser
  class TotalImageWeightCheck < Checks
    # Initialize a total image weight check.
    #
    # @param image_urls [Array] Image URLs that you would like to fetch the
    #   total image weight for.
    #
    # @return [Nothing].
    def initialize(image_urls)
      @total_image_weight = 0
      get_total_image_weight(image_urls)
    end

    # Format the results into a usable Hash.
    #
    # @return [Hash] `:total_image_weight` is the total image size in bytes.
    def to_h
      {
        :total_image_weight => @total_image_weight
      }
    end

    private

    def get_total_image_weight(image_urls)
      image_urls.each do |image|
        response = Net::HTTP.get_response(URI.parse(image))
        @total_image_weight += response.content_length
      end
    end
  end
end
