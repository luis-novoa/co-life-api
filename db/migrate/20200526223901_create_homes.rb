class CreateHomes < ActiveRecord::Migration[6.0]
  def change
    create_table :homes do |t|
      t.string :title
      t.string :address
      t.string :city
      t.string :country
      t.decimal :rent
      t.string :room_type
      t.text :more_info
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
