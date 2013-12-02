require 'active_record'
require 'active_support'

module AliceSaid
  class Character < ActiveRecord::Base
    has_many :image_characters
    has_many :characters, :through => :image_characters
  end
end
