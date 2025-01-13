class AddAverageRatingToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :average_rating, :integer
  end
end
