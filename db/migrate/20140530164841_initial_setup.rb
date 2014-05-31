class InitialSetup < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
    end

    create_table :items do |t|
      t.string :price
      t.string :name
      t.string :description
      t.string :store
      t.references :category
    end
        
  end
end
