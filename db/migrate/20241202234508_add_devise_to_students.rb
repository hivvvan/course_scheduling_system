class AddDeviseToStudents < ActiveRecord::Migration[8.0]
  def change
    change_table :students do |t|
      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at
    end

    add_index :students, :reset_password_token, unique: true
  end
end
