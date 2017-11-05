class AddUserIdToComicbooks < ActiveRecord::Migration[5.1]
  def change
    add_column :comicbooks, :user_id, :integer
  end
end
