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
  baloon_obj = Baloon.new(base_width: base_width, base_height: base_height,
                          x: base_width / 2, y: base_height / 2,
                          width: 180, height: 300,
                          phrase: "あああああああああ\nいいいいいいいいいい\nううううううううう" )
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
    @height = 200
    @width = @height / 1.6
  end

  def create
    @rvg = RVG.new(@base_width, @base_height).viewbox(0, 0, @base_width, @base_height) do |canvas|
      canvas.background_fill = 'black'
      canvas.background_fill_opacity = 0.0

      canvas.g do |body|
        body.styles(fill: 'white', stroke: 'rgb(100, 100, 100)', stroke_width: 1.5)
        body.ellipse(@width, @height, @base_width / 2, @base_height / 2)

        body.text(@base_width / 2, @base_height / 2) do |title|
          title.tspan(@phrase)
               .styles(text_anchor: 'start', font_size: 20, font_family: 'helvetica', fill: 'black',
                        writing_mode: 'tb', glyph_orientation_vertical: 0)
        end
      end
    end

    @rvg.draw.write('baloon.png')
    Magick::Image.read('baloon.png').shift
  end

end
