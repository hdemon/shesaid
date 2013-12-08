require "rmagick"
require 'rvg/rvg'
require 'pry'
include Magick


class Baloon
  RVG::dpi = 72

  def initialize(args)
    @x = args[:x]
    @y = args[:y]
    @width = args[:width]
    @height = args[:height]
    @phrase = args[:phrase]
    @color = 'white'
  end

  def set_base(base)
    @base_width = base.width
    @base_height = base.height
    self
  end

  def set_face(face)
    @face = face
    self
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

  def barb_location
  end
end


class Barb
  def initialize(args)
    @baloon = args[:baloon]
    @face = args[:face]
    @color = 'white'

            head.polygon(30,0, 70,5, 30,10, 62,25, 23,20).styles(:fill=>'orange')
        slope = (@face.mouth.y - @center_y) / (@face.mouth.x - @center_x)
  end
end

class Phrase
  def initialize(args)
    @phrase = args[:phrase].split("\\n")

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