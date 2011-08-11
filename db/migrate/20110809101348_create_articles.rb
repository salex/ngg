class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :group_id
      t.integer :user_id
      t.string :title
      t.text :body
      t.boolean :published
      t.datetime :published_at
      t.string :type_article

      t.timestamps
    end
  end
end
