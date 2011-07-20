class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :group_id
      t.string :username
      t.string :email
      t.string :login
      t.string :password_hash
      t.string :password_salt
      t.string :token
      t.datetime :token_expires
      t.datetime :confirmed_at
      t.string :last_name
      t.string :first_name
      t.string :phone
      t.string :cell
      t.string :address
      t.string :list_contact
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
