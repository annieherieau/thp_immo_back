class CreateListings < ActiveRecord::Migration[7.1]
  def change
    create_table :listings do |t|
      t.string :title, null: false
      t.string :address, :default => ""
      t.text :description, null: false
      t.integer :price, :default => 0
      t.belongs_to :city, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
