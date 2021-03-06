# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shesaid/version'
require 'pry'

Gem::Specification.new do |spec|
  spec.name          = "shesaid"
  spec.version       = SheSaid::VERSION
  spec.authors       = ["Masami Yonehara"]
  spec.email         = ["zeitdiebe@gmail.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activerecord"
  spec.add_runtime_dependency "sinatra"
  spec.add_runtime_dependency "sinatra-activerecord"
  spec.add_runtime_dependency "google-search"
  spec.add_runtime_dependency "sqlite3"
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "rmagick"
  spec.add_runtime_dependency "blf"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec"
end
