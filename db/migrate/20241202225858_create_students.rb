class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :student_id, null: false

      t.timestamps
    end

    add_index :students, :email, unique: true
    add_index :students, :student_id, unique: true
  end
end
