class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :color
      t.decimal :price

      t.timestamps
    end
  end
end
