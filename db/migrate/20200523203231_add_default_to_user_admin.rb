class AddDefaultToUserAdmin < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :admin, :boolean, default: false
  end
  
  def down
    change_column :users, :admin, :boolean, default: nil
  end
end
