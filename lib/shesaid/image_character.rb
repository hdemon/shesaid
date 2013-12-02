require 'active_record'
require 'active_support'

module SheSaid
  class ImageCharacter < ActiveRecord::Base
    belongs_to :characters
    belongs_to :images
  end
end
