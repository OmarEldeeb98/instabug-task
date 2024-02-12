class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.string :name
      t.integer :chats_count
      t.string :token
      t.timestamps
    end

    add_index :applications, :token, unique: true
  end
end
