class CreateAdmins < ActiveRecord::Migration[7.2]
  def change
    create_table :admins do |t|
      t.string :name, null: false
      t.string :password_digest, null: false
      t.date :effective_from, null: false
      t.date :effective_to
      t.boolean :account_locked, null: false, default: false
      t.integer :failed_attempts, null: false, default: 0
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
  end
end
