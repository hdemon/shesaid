require "./lib/shesaid"

get '/' do
  'hoge'
end

crawler = SheSaid::Crawler.new
puts crawler.get_uris

