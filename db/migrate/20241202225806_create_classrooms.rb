class CreateClassrooms < ActiveRecord::Migration[8.0]
  def change
    create_table :classrooms do |t|
      t.string :building, null: false
      t.string :room_number, null: false
      t.integer :capacity
      t.timestamps
    end

    add_index :classrooms, [ :building, :room_number ], unique: true
  end
end
