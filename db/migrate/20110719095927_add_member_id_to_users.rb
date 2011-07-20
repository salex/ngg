class AddMemberIdToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :status
    remove_column :users, :list_contact
    remove_column :users, :address
    remove_column :users, :cell
    remove_column :users, :phone
    remove_column :users, :first_name
    remove_column :users, :last_name
    add_column :users, :roles, :string
    add_column :users, :member_id, :integer
    
  end
end
