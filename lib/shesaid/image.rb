require 'google-search'
require 'active_support'
require "AnimeFace"


module SheSaid
  class Image
    attr_reader :image_blob, :rmagick_obj

    def initialize rmagick_obj
      @rmagick_obj = rmagick_obj
    end

    # def blob
    #   open(@image_uri) {|data| data.read }
    # rescue OpenURI::HTTPError
    #   puts "404 not found."
    #   nil
    # end

    def height
      @rmagick_obj.rows
    end

    def width
      @rmagick_obj.columns
    end
  end
end
