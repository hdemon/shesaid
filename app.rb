require "./lib/shesaid"

get '/' do
  image = SheSaid::Image.first offset: rand(SheSaid::Image.count)
  headers 'Content-Type' => "image/jpeg"
  image[:blob]
end
