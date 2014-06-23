require 'pry'


class BaloonImage
  def initialize(base_image:)
    face = SheSaid::Face.new base_image.rmagick_obj

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
end
