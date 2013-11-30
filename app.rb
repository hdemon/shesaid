require "./lib/alicesaid"

get '/' do
  'hoge'
end

crawler = AliceSaid::Crawler.new
puts crawler.get_uris

