require 'google-search'
require "RMagick"
require "AnimeFace"

module AliceSaid
  class Image < ActiveRecord::Base

    attr_reader :blob

    def initialize(google_image)
      @uri = google_image.uri
      @title = google_image.title
    end

    def blob
      _blob = nil
      open(@uri) do |data|
        _blob = data.read
      end
      _blob
    end

    def face?

    end
  end
end
