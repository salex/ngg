class AddAttendeesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :attendees, :integer
    add_column :events, :status, :string
  end
end
