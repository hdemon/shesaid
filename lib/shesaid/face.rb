require "shesaid/box"

class Face < Box
  attr_reader :start_x, :start_y, :width, :height, :end_x, :end_y, :center_x, :center_y

  def initialize(face_hash)
    face = face_hash["face"]
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
