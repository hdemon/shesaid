class SheSaid::BaloonImage
  def initialize(base_image: nil, text: "", font_size: 24)
    @base_image = SheSaid::Image.new base_image.rmagick_obj
    @face = SheSaid::Face.new base_image.rmagick_obj

    # @x = args[:x]
    # @y = args[:y]
    # @width = args[:width]
    # @height = args[:height]
    # @phrase = args[:phrase]
    # @color = 'white'
  end

  def draw
    location = fitting_location

    @rvg = RVG.new(@base_image.width, @base_image.height).viewbox(0, 0, @base_image.width, @base_image.height) do |canvas|
      canvas.background_fill = 'black'
      canvas.background_fill_opacity = 0.0

      canvas.g do |body|
        body.styles(fill: 'white', stroke: 'rgb(100, 100, 100)', stroke_width: 1.5)
        pp location
        body.ellipse(location.width, location.height, location.start_x, location.start_y)

        # phrase = Phrase.new(phrase: @phrase,
        #                     base_canvas: body,
        #                     font_size: @base_height / 20,
        #                     x: @x, y: @y - (@height / 2) * 1.2)
        # phrase.create
      end
    end

    @rvg.draw.write('baloon.png')
    @rvg.canvas
  end

  def fitting_location
    world = BLF::World.new width: @base_image.width,
                           height: @base_image.height
    world.add_block_with_location x: @face.start_x,
                                  y: @face.start_y,
                                  width: @face.width,
                                  height: @face.height
    world.add_block width: @base_image.width / 6,
                    height: @base_image.height / 3.7
    world.allocate_all
    world.placed_blocks
    world.placed_blocks.pop
  end
end
