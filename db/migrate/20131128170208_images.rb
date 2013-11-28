class Images < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :character_id
      t.binary  :blob
      t.integer :width
      t.integer :height
    end
  end
end
