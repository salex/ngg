class AddLimitGrossPointToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :limit_gross_points, :boolean
  end
end
