class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :subdomain

      t.timestamps
    end
  end
end
