require "rmagick"
require 'rvg/rvg'
include Magick


class Screen
  attr_reader :object

  def initialize(blob)
    @blob = blob
    @object = Magick::Image.from_blob(@blob).shift
  end

  def composite(rmagick_object)
    @object = @object.composite rmagick_object, CenterGravity, 0, 0, OverCompositeOp
  end

  def width
    @object.columns
  end

  def height
    @object.rows
  end

  def blob
    @object.to_blob
  end
end
