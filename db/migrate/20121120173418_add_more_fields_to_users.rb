class AddMoreFieldsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :wmata_key
    end
  end
end
