$:.unshift File.dirname(__FILE__) + "/lib"
require "pry"
require "./lib/alicesaid"

crawler = AliceSaid::Crawler.new
searched_images = crawler.get_image_info

face_images = searched_images.select do |google_image|
  image = AliceSaid::Image.new
  image.set_source_image google_image
  binding.pry
  puts "#{image.title} + face?  #{image.face?}"
  if image.blob.nil?
    false
  else
    image.face?
  end
end

face_images.each do |image|
  image.save
end
