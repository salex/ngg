class AddPotSplitsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :pot_splits, :string
  end
end
