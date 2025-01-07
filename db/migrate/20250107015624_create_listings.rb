class CreateListings < ActiveRecord::Migration[8.0]
  def change
    create_table :listings do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.string :location
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
