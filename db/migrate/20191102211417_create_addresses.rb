class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :alias, default: 'Home'

      t.timestamps
    end
  end
end
