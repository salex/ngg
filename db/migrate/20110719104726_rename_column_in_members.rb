class RenameColumnInMembers < ActiveRecord::Migration
  def change
    rename_column :members, :fist_name, :first_name
  end

end
