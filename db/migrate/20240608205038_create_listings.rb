class CreateListings < ActiveRecord::Migration[7.1]
  def change
    create_table :listings do |t|
      t.string :title, null: false
      t.string :address, :default => ""
      t.text :description, null: false
      t.integer :price, :default => 0
      t.belongs_to :city, foreign_key: true, null: false
      t.belongs_to :user, index: true, null: false

      t.timestamps
    end
  end
end
