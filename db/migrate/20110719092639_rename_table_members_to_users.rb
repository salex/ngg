class RenameTableMembersToUsers < ActiveRecord::Migration
  def up
    rename_table(:members,:users)
  end

  def down
    rename_table(:users,:members)
  end
end
