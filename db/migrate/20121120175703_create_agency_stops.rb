class CreateAgencyStops < ActiveRecord::Migration
  def change
    create_table :agency_stops do |t|
      t.integer :block_id
      t.string :agency
      t.string :stop_id
      t.string :exclusions

      t.timestamps
    end
  end
end
