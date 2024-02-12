class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.integer :message_number
      t.string :body
      t.timestamps
    end
  end
end
