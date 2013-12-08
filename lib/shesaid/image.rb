require 'google-search'
require 'active_record'
require 'active_support'
require "rmagick"
require "AnimeFace"


module SheSaid
  class Image < ActiveRecord::Base
    has_many :image_characters
    has_many :images, :through => :image_characters

    serialize :face_data

    attr_reader :uri, :title, :blob, :content

    def set_source_image(google_image)
      @scraped = false

      self.uri = @uri = google_image.uri
      self.title = @title = google_image.title
      self.blob = @blob = blob
      if self.blob.present?
        @rmagick_obj = Magick::Image.from_blob(self.blob).shift
      else
        @rmagick_obj = NilRMagickObject.new
      end

      self.height = @rmagick_obj.rows
      self.width = @rmagick_obj.columns
      self.face_data = anime_face(@rmagick_obj)
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
      return if blob.nil?
      @anime_face ||= AnimeFace::detect(rmagick_obj)
    end

    def scraped?
      @scraped
    end

    def face?
      return false unless scraped?

      self.face_data.present?
    end
  end

  class NilRMagickObject
    def blob
      nil
    end

    def rows
      nil
    end

    def columns
      nil
    end
  end
end

