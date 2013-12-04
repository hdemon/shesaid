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

  baloon_height = args[:material].height / 3.7
  baloon_width = baloon_height / 1.6

  baloon_obj = Baloon.new(base_width: base_width, base_height: base_height,
                          x: base_width / 2, y: base_height / 2,
                          width: baloon_width, height: baloon_height,
                          phrase: "進捗\nどうですか")
                     .create

  overprinted_obj = image_obj.composite baloon_obj, CenterGravity, 0, 0, OverCompositeOp
  # overprinted_obj.to_blob

  face = args[:material][:face_data].first["face"]

  face_box = FaceBox.new(start_x: face["x"], start_y: face["y"], width: face["width"], height: face["height"])
  face_box.set_base(base_width, base_height)
  face_box_obj = face_box.create
  overprinted_obj = overprinted_obj.composite face_box_obj, CenterGravity, 0, 0, OverCompositeOp

  # baloon_area_box = FaceBox.new(
  #   start_x: @start_x - face_box[:width] * PADDING[:left],
  #   start_y: @start_y - face_box[:height] * PADDING[:top],
  #   end_x: (@start_x + @width) + face_box[:width] * PADDING[:right],
  #   end_y: (@start_y + @height) + face_box[:height] * PADDING[:bottom] )

  # baloon_area_box.set_base(base_width, base_height)
  # baloon_area_box_obj = baloon_area_box.create
  # overprinted_obj = overprinted_obj.composite baloon_area_box_obj, CenterGravity, 0, 0, OverCompositeOp
 # face_box = FaceBox.new(base_width: base_width, base_height: base_height, face: face).create
  # baloon_area_obj = BaloonArea.new(base_width: base_width, base_height: base_height, face: face).create

  overprinted_obj.to_blob
end

def magick_image_obj(blob)
  Magick::Image.from_blob(blob).shift
end
