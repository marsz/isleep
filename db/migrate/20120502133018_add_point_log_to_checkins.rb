class AddPointLogToCheckins < ActiveRecord::Migration
  def change
    add_column :checkins, :point_log, :text
  end
end
