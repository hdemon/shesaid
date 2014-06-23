class Box
  def initialize(args)
    @start_x = args[:start_x]
    @start_y = args[:start_y]
    @width = args[:width]
    @height = args[:height]
    @end_x = args[:end_x] || @start_x + @width
    @end_y = args[:end_y] || @start_y + @height

    @screen = args[:screen]
  end

  def set_base(base_width, base_height)
    @base_width = base_width
    @base_height = base_height
  end

  def create
    img = Magick::Image.new(@screen.width, @screen.height) {
      self.background_color = "Transparent"
    }
    gc = Magick::Draw.new

    gc.stroke("#000000")
    gc.stroke_width(1)
    gc.fill 'rgba(0,0,0,0)'
    gc.rectangle(@start_x, @start_y, @end_x, @end_y)
    gc.draw img
    img.write("box.png")
    Magick::Image.read('box.png').shift
  end
end
