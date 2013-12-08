require "./lib/shesaid"
require "rmagick"
require 'rvg/rvg'
include Magick


get '/' do
  headers 'Content-Type' => "image/jpeg"
  baloon_overprinted_image(material: image, phrase: params[:phrase])
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

  face_hash = args[:material][:face_data].first
  face = Face.new(face_hash)

  draw_baloon_on screen, face, args[:phrase]
  draw_face_box_on screen, face

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

def draw_face_box_on(screen, face)
  face_box = FaceBox.new(start_x: face.start_x, start_y: face.start_y, width: face.width, height: face.height)
  face_box.set_base(screen.width, screen.height)
  face_box_obj = face_box.create
  screen.composite face_box_obj
end

def draw_baloon_on(screen, face, phrase)
  baloon_height = screen.height / 3.7
  baloon_width = baloon_height / 1.6

  baloon_center_x = face.start_x + face.width + baloon_width
  baloon_center_y = face.start_y + random * face.height * 1.5
  baloon_obj = Baloon.new(x: baloon_center_x, y: baloon_center_y,
                          width: baloon_width, height: baloon_height,
                          phrase: phrase)

  screen.composite baloon_obj.set_base(screen).create
end

def random
  Random.new(Random.new_seed).rand
end