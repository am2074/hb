class RenameLocationToAddress < ActiveRecord::Migration[5.2]
 def change
  	rename_column :reviews, :location, :address
  end
end
