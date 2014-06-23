require "blf"
require "shesaid/box"


class BaloonArea < Box
  PADDING = { top: 0.2, right: 0.8, bottom: 0.4, left: 0.8 }

  attr_reader :start_x, :start_y, :width, :height, :baloon_block, :world

  def initialize(args)
    @screen = args[:screen]
    @face = args[:face]

    @start_x = @face.start_x - @face.width * PADDING[:left]
    @start_y = @face.start_y - @face.height * PADDING[:top]
    @start_x = 0 if @start_x < 0
    @start_y = 0 if @start_y < 0
    @end_x = @face.end_x + @face.width * PADDING[:right]
    @end_x = @screen.width if @end_x > @screen.width
    @end_y = @face.end_y + @face.height * PADDING[:bottom]
    @end_y = @screen.height if @end_y > @screen.height
    @width = @end_x - @start_x
    @height = @end_y - @start_y
  end

  def allocate
    @world = BLF::World.new width: @width, height: @height
    @world.add_block_with_location x: @face.start_x - @start_x, y: @face.start_y - @start_y, width: @face.width, height: @face.height
    @world.add_block width: @screen.width / 6, height: @screen.height / 3.7
    @world.allocate_all
    calc_location
  end

  def calc_location
    @baloon_block ||= @world.placed_blocks.pop
  end
end
