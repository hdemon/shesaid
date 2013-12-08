require "rmagick"
require 'rvg/rvg'
require 'pp'
include Magick



class BaloonArea
  PADDING = { top: 0.2, right: 0.6, bottom: 0.4, left: 0.6 }

  def initialize(args)
    @base_width = args[:base_width]
    @base_height = args[:base_height]
    @face = args[:face]
  end

  def wrapper_box
    @wrapper_box ||= {
      start_x: @start_x - face_box[:width] * PADDING[:left],
      start_y: @start_y - face_box[:height] * PADDING[:top],
      width: @width,
      height: @height,
      end_x: (@start_x + @width) + face_box[:width] * PADDING[:right],
      end_y: (@start_y + @height) + face_box[:height] * PADDING[:bottom],
    }
  end

  def create
    img = Magick::Image.new(@base_width, @base_height) {
      self.background_color = "Transparent"
    }
    gc = Magick::Draw.new

    gc.stroke("#000000")
    gc.stroke_width(1)
    gc.fill 'rgba(0,0,0,0)'
    gc.rectangle(face_box[:start_x], face_box[:start_y], face_box[:end_x], face_box[:end_y])
    gc.rectangle(wrapper_box[:start_x], wrapper_box[:start_y], wrapper_box[:end_x], wrapper_box[:end_y])
    gc.draw img
    img.write("baloon_area.png")
    Magick::Image.read('baloon_area.png').shift
  end
end
