require 'net/http'
require 'uri'
require 'nokogiri'

module EnvatoOptimiser
  class Item
    def initialize(url)
      @url = url
    end

    # Public: Perform analysis against the given item URL.
    #
    # Returns a Hash of the check values from each subclass.
    def check!
      image_check = EnvatoOptimiser::ImageCheck.new(@url).run!
    end
  end
end
