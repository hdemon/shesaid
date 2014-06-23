lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require './lib/shesaid'


images = SheSaid::Images.new(who: 'きんいろモザイク　アリス', what: 'test')
image = SheSaid::OverPrinted.new images[0]
image