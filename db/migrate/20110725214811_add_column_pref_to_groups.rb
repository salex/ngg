class AddColumnPrefToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :uses_multiple_courses, :boolean
    add_column :groups, :uses_course_quota, :boolean
    add_column :groups, :uses_best_rounds, :boolean
    add_column :groups, :best_rounds_minimum, :integer
    add_column :groups, :best_rounds_maximum, :integer
    add_column :groups, :rounds_used, :integer
    add_column :groups, :uses_new_member_limit, :boolean
    add_column :groups, :new_member_limit, :integer
    add_column :groups, :new_member_rounds_used, :integer
    add_column :groups, :uses_round_limit, :boolean
    add_column :groups, :round_limit, :integer
    add_column :groups, :uses_new_course_limit, :boolean
    add_column :groups, :uses_high_low_rounds_rule, :boolean
    add_column :groups, :high_low_rounds_effective, :integer
    add_column :groups, :round_dues, :float
    add_column :groups, :skins_dues, :float
    add_column :groups, :other_game, :float
    add_column :groups, :other_dues, :float
    add_column :groups, :points_double_eagle, :integer
    add_column :groups, :points_eagle, :integer
    add_column :groups, :points_birdie, :integer
    add_column :groups, :points_par, :integer
    add_column :groups, :points_bogey, :integer
    add_column :groups, :points_double_bogey, :integer
  end
end
