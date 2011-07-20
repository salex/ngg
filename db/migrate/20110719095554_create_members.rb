class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :group_id
      t.string :email
      t.string :last_name
      t.string :fist_name
      t.string :phone
      t.string :cell
      t.text :address
      t.boolean :list_contact
      t.string :status

      t.timestamps
    end
  end
end
