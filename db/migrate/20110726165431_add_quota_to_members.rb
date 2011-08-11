class AddQuotaToMembers < ActiveRecord::Migration
  def change
    add_column :members, :quota, :integer
    add_column :members, :limited, :boolean
    add_column :members, :initial_quota, :integer
    add_column :members, :tee, :string, :limit => 1
  end
end
