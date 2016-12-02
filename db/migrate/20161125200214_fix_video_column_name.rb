class FixVideoColumnName < ActiveRecord::Migration
  def change
    rename_column :videos, :desctiption, :description
  end
end
