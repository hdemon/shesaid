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