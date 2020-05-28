class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :home, null: false, foreign_key: true
      t.string :user_home, null:false

      t.timestamps
    end
  end
end
