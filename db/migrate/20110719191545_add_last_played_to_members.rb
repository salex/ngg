class AddLastPlayedToMembers < ActiveRecord::Migration
  def change
    add_column :members, :last_played, :date
  end
end
