class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.text :Event_ID
      t.text :Event_Name
      t.date :Event_Date
      t.numeric :Event_Time

      t.timestamps
    end
  end
end
