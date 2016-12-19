class RenameColumnCreatedOnReviews < ActiveRecord::Migration
  def change
    rename_column :reviews, :crated_at, :created_at
  end
end
