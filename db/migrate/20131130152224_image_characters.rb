class ImageCharacters < ActiveRecord::Migration
  def up
    create_table :image_characters do |t|
      t.integer :character_id, null: false
      t.integer :image_id, null: false
      t.timestamps
    end
  end

  def down
  end
end
