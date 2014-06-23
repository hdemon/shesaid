require "./lib/shesaid"
require 'rvg/rvg'


get '/' do
  headers 'Content-Type' => "image/jpeg"
  raw_image = get_raw_image params[:phrase]

  baloon_overprinted_image material: face_image, phrase: params[:phrase]
end

def character_id
  if params[:character].present?
    SheSaid::Character.where(name: params[:character]).shift.id
  else
    SheSaid::Character.first(offset: rand(SheSaid::Character.count)).id
  end
end

def get_raw_image
end

def face_image
  images = SheSaid::Image.where id: SheSaid::ImageCharacter.where(character_id: character_id)
  images.first offset: rand(images.count)
end

def baloon_overprinted_image(args)
  screen = Screen.new args[:material][:blob]

  face_hash = args[:material][:face_data].first
  face = Face.new face_hash

  draw_baloon screen: screen, face: face, phrase: args[:phrase]
  draw_face_box screen: screen, face: face

  screen.object.to_blob
end

def magick_image_obj(blob)
  Magick::Image.from_blob(blob).shift
end

def draw_face_box(args)
  screen = args[:screen]
  face = args[:face]

  face_box = FaceBox.new(start_x: face.start_x, start_y: face.start_y, width: face.width, height: face.height, screen: screen)
  face_box.set_base(screen.width, screen.height)
  face_box_obj = face_box.create
  screen.composite face_box_obj
end

def draw_baloon(args)
  screen = args[:screen]
  face = args[:face]
  baloon = {}
  baloon[:height] = screen.height / 3.7
  baloon[:width] = baloon[:height] / 1.6

  baloon_area = BaloonArea.new face: face, baloon: baloon, screen: screen
  baloon_area.allocate

  screen.composite baloon_area.create

  baloon_obj = Baloon.new(x: (baloon_area.baloon_block.start_x + baloon_area.start_x + baloon[:width] / 2), y: (baloon_area.baloon_block.start_y + baloon_area.start_y + baloon[:height] / 2),
                          width: baloon[:width], height: baloon[:height],
                          phrase: args[:phrase])
  baloon_obj.set_base screen

  screen.composite baloon_obj.create
end

def random
  Random.new(Random.new_seed).rand
end
