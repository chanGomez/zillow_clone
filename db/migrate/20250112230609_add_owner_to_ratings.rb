class AddOwnerToRatings < ActiveRecord::Migration[8.0]
  def change
    add_column :ratings, :owner_id, :bigint
  end
end
