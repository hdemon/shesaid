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
  screen = Screen.new(args[:material][:blob])

  draw_baloon_on screen

  face_info = args[:material][:face_data].first["face"]
  draw_face_box_on screen, face_info

  # baloon_area_box = FaceBox.new(
  #   start_x: @start_x - face_box[:width] * PADDING[:left],
  #   start_y: @start_y - face_box[:height] * PADDING[:top],
  #   end_x: (@start_x + @width) + face_box[:width] * PADDING[:right],
  #   end_y: (@start_y + @height) + face_box[:height] * PADDING[:bottom] )

  screen.object.to_blob
end

def magick_image_obj(blob)
  Magick::Image.from_blob(blob).shift
end

def draw_face_box_on(screen, face_info)
  face_box = FaceBox.new(start_x: face_info["x"], start_y: face_info["y"], width: face_info["width"], height: face_info["height"])
  face_box.set_base(screen.width, screen.height)
  face_box_obj = face_box.create
  screen.composite face_box_obj
end

def draw_baloon_on(screen)
  baloon_height = screen.height / 3.7
  baloon_width = baloon_height / 1.6

  baloon_obj = Baloon.new(x: screen.width / 2, y: screen.height / 2,
                          width: baloon_width, height: baloon_height,
                          phrase: "進捗\nどうですか")

  screen.composite baloon_obj.set_base(screen).create
end

