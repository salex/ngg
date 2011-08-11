class CreateQuotas < ActiveRecord::Migration
  def change
    create_table :quotas do |t|
      t.integer :member_id
      t.integer :tee_id
      t.integer :quota
      t.date :last_played
      t.text :history
      t.boolean :limited

      t.timestamps
    end
  end
end
