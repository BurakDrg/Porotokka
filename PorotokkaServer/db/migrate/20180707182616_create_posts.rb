class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :event_id
      t.string :event_name
      t.string :event_date
      t.string :event_time

      t.timestamps
    end
  end
end
