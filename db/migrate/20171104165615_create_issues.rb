class CreateIssues < ActiveRecord::Migration[5.1]
  def change
    create_table :issues do |t|
      t.string :title
      t.integer :issue_number
      t.integer :cover_date
      t.integer :comicbook_id
      t.integer :author_id

    end
  end
end
