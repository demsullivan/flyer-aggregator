class InitialSetup < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :base_url
      t.string :parser_name
    end

    create_table :user_stores do |t|
      t.integer :store_id
      t.references :companies
      t.references :ar_users
    end

    create_table :categories do |t|
      t.string :name
      t.references :ar_users
    end

    create_table :items do |t|
      t.string :price
      t.string :name
      t.string :description
      t.string :store
      t.integer :store_id
      t.references :category
    end
        
  end
end
