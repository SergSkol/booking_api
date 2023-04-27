class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.string :photo, default: 'https://images.pexels.com/photos/258154/pexels-photo-258154.jpeg'
      t.string :location
      t.float :price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
