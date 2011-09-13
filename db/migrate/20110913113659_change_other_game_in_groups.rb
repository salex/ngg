class ChangeOtherGameInGroups < ActiveRecord::Migration
  def up
    change_column :groups, :other_game, :string
  end

  def down
  end
end
