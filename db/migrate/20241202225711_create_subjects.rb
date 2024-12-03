class CreateSubjects < ActiveRecord::Migration[8.0]
  def change
    create_table :subjects do |t|
      t.string :code, null: false  # e.g., "CHEM101"
      t.string :name, null: false  # e.g., "General Chemistry 1"
      t.text :description

      t.timestamps
    end

    add_index :subjects, :code, unique: true
  end
end
