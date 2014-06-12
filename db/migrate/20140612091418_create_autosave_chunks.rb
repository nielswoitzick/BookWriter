class CreateAutosaveChunks < ActiveRecord::Migration
  def change
    create_table :autosave_chunks do |t|
      t.string :title
      t.string :section
      t.text :content
      t.references :chunk

      t.timestamps
    end
  end
end
