class Images < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :character_id
      t.text :title
      t.text :uri
      t.binary :blob, limit: 10485760
      t.text :face_data
      t.integer :width
      t.integer :height
    end
  end
end
