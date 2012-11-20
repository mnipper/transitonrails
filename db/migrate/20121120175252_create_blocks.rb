class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|

      t.integer :screen_id
      t.string :stop
      t.string :custom_name
      t.integer :column
      t.integer :position
      t.text :custom_body
      t.integer :limit

      t.timestamps
    end
  end
end
