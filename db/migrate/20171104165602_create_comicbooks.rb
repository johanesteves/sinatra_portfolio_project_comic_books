class CreateComicbooks < ActiveRecord::Migration[5.1]
  def change
    create_table :comicbooks do |t|
      t.string :title
      t.integer :author_id
    end
  end
end
