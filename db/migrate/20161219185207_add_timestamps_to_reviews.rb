class AddTimestampsToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :crated_at, :datetime
    add_column :reviews, :updated_at, :datetime
  end
end
