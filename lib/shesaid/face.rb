require "shesaid/box"
require "AnimeFace"
require "pp"

class SheSaid::Face < Box
  attr_reader :start_x, :start_y, :width, :height, :end_x, :end_y, :center_x, :center_y

  def initialize(rmagick_obj)
    anime_face_object = AnimeFace::detect(rmagick_obj).shift
    face = anime_face_object["face"]

    @start_x = face["x"]
    @start_y = face["y"]
    @width = face["width"]
    @height = face["height"]
    @end_x = @start_x + @width
    @end_y = @start_y + @height
    @center_x = (@end_x - @start_x) / 2 + @start_x
    @center_y = (@end_y - @start_y) / 2 + @start_y
  end
end
