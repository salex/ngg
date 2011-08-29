class AddTrimRoundsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :trim_round_days, :integer
  end
end
