class Characters < ActiveRecord::Migration
  def up
    create_table :characters do |t|
      t.text :name
      t.text :search_word
    end
  end

  def down
  end
end
