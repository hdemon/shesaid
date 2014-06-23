require "shesaid/version"
require "shesaid/crawler"
require "shesaid/image"
require "shesaid/baloon_image"
require "shesaid/baloon_area"
require "shesaid/box"
require "shesaid/screen"
require "shesaid/face"
require 'rvg/rvg'
require 'google-search'
require 'open-uri'
require 'pp'

include Magick
RVG::dpi = 72


module SheSaid
  class Images
    def initialize(who: '', what: '')
      @who = who
      @what = what
    end

    def [](index)
      resource image_urls[index]
    end

    def resource(url)
      # open(url) {|data| data.read }
      open("http://blog-imgs-65.fc2.com/e/r/r/errorpokenosaikuru/11395887.jpg") {|data| data.read }
    rescue OpenURI::HTTPError
      puts "404 not found."
      nil
    end

    private

    def image_urls
      @cache_image_urls ||= Google::Search::Image.new(query: @who).each_with_object([]) { |image, memo| memo << image.uri }
    end
  end

  class OverPrinted
    def initialize(image_blob)
      @image_blob = image_blob
      @base_image = SheSaid::Image.new(Magick::Image.from_blob(@image_blob).shift)
      @baloon_image = SheSaid::BaloonImage.new(base_image: @base_image)
      @baloon_image.draw
    end

    def overprinted_image
      @base_image.coposite @baloon_image
    end

    def baloon_overprinted_image(args)
      screen = Screen.new args[:material][:blob]

      face_hash = args[:material][:face_data].first
      face = Face.new face_hash

      draw_baloon screen: screen, face: face, phrase: args[:phrase]
      draw_face_box screen: screen, face: face

      screen.object.to_blob
    end

    def draw_baloon(args)
      screen = args[:screen]
      face = args[:face]
      baloon = {}
      baloon[:height] = screen.height / 3.7
      baloon[:width] = baloon[:height] / 1.6

      baloon_area = BaloonArea.new face: face, baloon: baloon, screen: screen
      baloon_area.allocate

      screen.composite baloon_area.create

      baloon_obj = Baloon.new(x: (baloon_area.baloon_block.start_x + baloon_area.start_x + baloon[:width] / 2), y: (baloon_area.baloon_block.start_y + baloon_area.start_y + baloon[:height] / 2),
                              width: baloon[:width], height: baloon[:height],
                              phrase: args[:phrase])
      baloon_obj.set_base screen

      screen.composite baloon_obj.create
    end

  end
end


#   def get_raw_image(search_phrase)

#   end

# def character_id
#   if params[:character].present?
#     SheSaid::Character.where(name: params[:character]).shift.id
#   else
#     SheSaid::Character.first(offset: rand(SheSaid::Character.count)).id
#   end
# end

# def get_raw_image
# end

# def face_image
#   images = SheSaid::Image.where id: SheSaid::ImageCharacter.where(character_id: character_id)
#   images.first offset: rand(images.count)
# end

# def baloon_overprinted_image(args)
#   screen = Screen.new args[:material][:blob]

#   face_hash = args[:material][:face_data].first
#   face = Face.new face_hash

#   draw_baloon screen: screen, face: face, phrase: args[:phrase]
#   draw_face_box screen: screen, face: face

#   screen.object.to_blob
# end

# def magick_image_obj(blob)
#   Magick::Image.from_blob(blob).shift
# end

# def draw_face_box(args)
#   screen = args[:screen]
#   face = args[:face]

#   face_box = FaceBox.new(start_x: face.start_x, start_y: face.start_y, width: face.width, height: face.height, screen: screen)
#   face_box.set_base(screen.width, screen.height)
#   face_box_obj = face_box.create
#   screen.composite face_box_obj
# end

# def draw_baloon(args)
#   screen = args[:screen]
#   face = args[:face]
#   baloon = {}
#   baloon[:height] = screen.height / 3.7
#   baloon[:width] = baloon[:height] / 1.6

#   baloon_area = BaloonArea.new face: face, baloon: baloon, screen: screen
#   baloon_area.allocate

#   screen.composite baloon_area.create

#   baloon_obj = Baloon.new(x: (baloon_area.baloon_block.start_x + baloon_area.start_x + baloon[:width] / 2), y: (baloon_area.baloon_block.start_y + baloon_area.start_y + baloon[:height] / 2),
#                           width: baloon[:width], height: baloon[:height],
#                           phrase: args[:phrase])
#   baloon_obj.set_base screen

#   screen.composite baloon_obj.create
# end

# def random
#   Random.new(Random.new_seed).rand
# end

