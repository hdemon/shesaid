require 'google-search'
require 'active_record'
require 'active_support'
require "RMagick"
require "AnimeFace"

module AliceSaid
  class Image < ActiveRecord::Base
    has_many :image_characters
    has_many :images, :through => :image_characters

    attr_reader :uri, :title, :blob, :content

    def set_source_image(google_image)
      @scraped = false

      self.uri = @uri = google_image.uri
      self.title = google_image.title
      self.blob = blob
      @rmagick_obj = Magick::Image.from_blob(self.blob).shift if self.blob.present?
      self.height = @rmagick_obj.try(:rows) || nil
      self.width = @rmagick_obj.try(:columns) || nil
    end

    def blob
      d = nil
      open(self.uri) {|data| d = data.read }
      @scraped = true
      d
    rescue OpenURI::HTTPError
      @scraped = false
      puts "404 not found."
      nil
    end

    def anime_face(rmagick_obj)
      @anime_face ||= AnimeFace::detect(rmagick_obj)
    end

    def scraped?
      @scraped
    end

    def face?
      return false unless scraped?
      result = anime_face(@rmagick_obj)
      result.present?
    end
  end
end
