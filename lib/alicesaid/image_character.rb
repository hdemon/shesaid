require 'active_record'
require 'active_support'

module AliceSaid
  class ImageCharacter < ActiveRecord::Base
    belongs_to :characters
    belongs_to :images
  end
end
