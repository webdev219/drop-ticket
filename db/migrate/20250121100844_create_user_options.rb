class CreateUserOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :user_options do |t|
      t.string :discord_id
      t.json :options, default: {}
      t.boolean :monitor, default: true
      t.datetime :sent_at

      t.timestamps
    end

    add_index :user_options, :discord_id, unique: true
  end
end
