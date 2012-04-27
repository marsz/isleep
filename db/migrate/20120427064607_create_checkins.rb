class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.integer :user_id
      t.date :date
      t.string :check_type
      t.string :note
      t.timestamps
    end
    add_index :checkins, :user_id
    add_index :checkins, :date
    add_index :checkins, :check_type
    add_index :checkins, [:user_id, :date, :check_type]
    add_index :checkins, [:user_id, :date]
    add_index :checkins, [:user_id, :check_type]
    add_index :checkins, [:date, :check_type]
  end
end
