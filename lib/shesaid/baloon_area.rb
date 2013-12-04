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



class Baloon
  RVG::dpi = 72

  def initialize(args)
    @base_width = args[:base_width]
    @base_height = args[:base_height]
    @x = args[:x]
    @y = args[:y]
    @width = args[:width]
    @height = args[:height]
    @phrase = args[:phrase]
    @color = 'white'
  end

  def create
    @rvg = RVG.new(@base_width, @base_height).viewbox(0, 0, @base_width, @base_height) do |canvas|
      canvas.background_fill = 'black'
      canvas.background_fill_opacity = 0.0

      canvas.g do |body|
        body.styles(fill: 'white', stroke: 'rgb(100, 100, 100)', stroke_width: 1.5)
        body.ellipse(@width, @height, @x, @y)

        phrase = Phrase.new(phrase: @phrase,
                            base_canvas: body,
                            font_size: @base_height / 20,
                            x: @x, y: @y - (@height / 2) * 1.2)
        phrase.create
      end
    end

    @rvg.draw.write('baloon.png')
    Magick::Image.read('baloon.png').shift
  end
end


class Phrase
  def initialize(args)
    @phrase = args[:phrase].split("\n")
    @line_number = @phrase.length
    @font_size = args[:font_size]
    @base_canvas = args[:base_canvas]
    @center_x = args[:x]
    @center_y = args[:y]
  end

  def create
    x = 0
    @phrase.each do |p|
      @base_canvas.text(@center_x + offset_x + x, @center_y) do |title|
        title.tspan(p)
             .styles(text_anchor: 'start', font_size: @font_size, font_weight: 100,
                     stroke: 'rgb(50, 50, 50)', fill: 'rgb(50, 50, 50)',
                     writing_mode: 'tb', glyph_orientation_vertical: 0)
      end
      x -= @font_size * 1.5
    end
  end

  def offset_x
    ((@line_number - 1) * (@font_size / 2)) + (@font_size / 2) * (@line_number - 1)
  end
end