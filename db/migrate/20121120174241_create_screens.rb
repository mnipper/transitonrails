class CreateScreens < ActiveRecord::Migration
  def change
    create_table :screens do |t|

      t.integer :user_id

      #Opening/Closing information lets screens know when they should sleep
      #will eventually offload this information into separate model and table
      t.datetime :monday_thursday_opening
      t.datetime :monday_thursday_closing
      t.datetime :friday_opening
      t.datetime :friday_closing
      t.datetime :saturday_opening
      t.datetime :saturday_closing
      t.datetime :sunday_opening
      t.datetime :sunday_closing

      t.string :name
      t.float :zoom
      t.datetime :last_check_in
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
