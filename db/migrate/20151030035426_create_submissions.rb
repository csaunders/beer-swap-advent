class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :user_id, unique: true, null: false
      t.integer :region, :integer, default: 0, null: false
      t.datetime :day, null: false
      t.string :name
      t.string :ibu
      t.string :abv
      t.string :srm
      t.text :recipe

      t.index :user_id
      t.index :region
    end
  end
end
