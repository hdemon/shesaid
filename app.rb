require "./lib/shesaid"

get '/' do
  images = SheSaid::Image.where(id: SheSaid::ImageCharacter.where(character_id: character_id))
  image = images.first(offset: rand(images.count))
                        # .first(offset: rand(SheSaid::Image.count))
  headers 'Content-Type' => "image/jpeg"
  image[:blob]
end

def character_id
  SheSaid::Character.where(name: params[:character]).shift.id
end
