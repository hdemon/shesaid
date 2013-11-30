require 'google-search'
require 'open-uri'

module AliceSaid
  class Crawler
    def get_image_info
      image_array = []
      Google::Search::Image.new(query: 'きんいろモザイク アリス').each { |image| image_array << image }
      image_array
    end
  end
end
