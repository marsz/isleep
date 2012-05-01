class AddColumnSleepTargetTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sleep_target, :time
    add_column :users, :sp, :integer, :default => 0
    add_column :users, :wakeup_target, :time
    add_column :users, :hp, :integer, :default => 0
  end
end
