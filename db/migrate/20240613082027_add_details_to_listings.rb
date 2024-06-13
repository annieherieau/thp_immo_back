class AddDetailsToListings < ActiveRecord::Migration[7.1]
  def change
    add_column :listings, :surface_area, :integer, default: 0, null: false
    add_column :listings, :number_of_rooms, :integer, default: 0, null: false
    add_column :listings, :furnished, :boolean, default: false, null: false
    add_column :listings, :bonus, :text, default: "", null: false
  end
end
