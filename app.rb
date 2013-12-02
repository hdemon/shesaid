require "./lib/shesaid"
require "rmagick"

get '/' do
  headers 'Content-Type' => "image/jpeg"
  set_baloon(material: image[:blob], sentence: params[:sentence])
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

def set_baloon(args)
  canvas = Magick::Image.from_blob(args[:material]).shift
  size = 30
  text = "あいうえおアリスLGTM陽子"
  draw = Magick::Draw.new
  draw.font "ipamp.ttf"
  draw.font_weight 900

  draw.annotate(canvas, 0, 0, 50, 100 + size, text) do
    self.font = 'Verdana-Bold'
    self.fill = '#FFFFFF'
    self.align = Magick::LeftAlign
    self.stroke = 'transparent'
    self.pointsize = 30
    self.text_antialias = true
    self.kerning = 1
  end
  canvas.to_blob

end