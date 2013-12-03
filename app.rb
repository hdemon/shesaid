require "./lib/shesaid"
require "rmagick"
require 'rvg/rvg'
include Magick

get '/' do
  headers 'Content-Type' => "image/jpeg"
  baloon_overprinted_image(material: image, sentence: params[:sentence])
end


def character_id
  if params[:character].present?
    SheSaid::Character.where(name: params[:character]).shift.id
  else
    SheSaid::Character.first(offset: rand(SheSaid::Character.count)).id
  end
end

def image
  images = SheSaid::Image.where(id: SheSaid::ImageCharacter.where(character_id: character_id))
  image = images.first(offset: rand(images.count))
end

def baloon_overprinted_image(args)
  image_obj = magick_image_obj args[:material][:blob]

  base_width = args[:material].width
  base_height = args[:material].height

  baloon_height = args[:material].height / 4
  baloon_width = baloon_height / 1.6

  baloon_obj = Baloon.new(base_width: base_width, base_height: base_height,
                          x: base_width / 2, y: base_height / 2,
                          width: baloon_width, height: baloon_height,
                          phrase: "進捗\nどうですか",
                      .create

  overprinted_obj = image_obj.composite baloon_obj, CenterGravity, 0, 0, OverCompositeOp
  overprinted_obj.to_blob
end

def magick_image_obj(blob)
  Magick::Image.from_blob(blob).shift
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
             .styles(text_anchor: 'start', font_size: @font_size, font_weight: 'lighter',
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