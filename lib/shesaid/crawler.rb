require 'google-search'
require 'open-uri'
require "pry"

module SheSaid
  class Crawler

    class << self
      def crawl
        config = YAML.load_file('characters.yml')
        config.each do |c|
          crawler = SheSaid::Crawler.new
          searched_images = crawler.get_image_info c["search_word"]

          face_images(searched_images).each do |google_image|
            image = SheSaid::Image.new
            image.set_source_image google_image

            if SheSaid::Image.where(uri: image.uri).empty?
              image.save
            end

            if SheSaid::Character.where(name: c["name"]).empty?
              character = SheSaid::Character.new
              character.name = c["name"]
              character.save
            end

            ic = SheSaid::ImageCharacter.new
            ic.character_id = SheSaid::Character.where(name: c["name"]).shift.id
            ic.image_id = SheSaid::Image.where(uri: image.uri).shift.id
            ic.save unless SheSaid::ImageCharacter.where(character_id: ic.character_id, image_id: ic.image_id).present?
          end
        end
      end

      def face_images(searched_images)
        searched_images.select do |google_image|
          image = SheSaid::Image.new
          image.set_source_image google_image

          puts "#{image.title}: face?:#{image.face?}"

          if image.blob.nil?
            false
          else
            image.face?
          end
        end
      end
    end

    def get_image_info(search_phrase)
      image_array = []
      Google::Search::Image.new(query: search_phrase).each { |image| image_array << image }
      image_array
    end
  end
end
