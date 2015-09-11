class ChangePicturesFields < ActiveRecord::Migration
  def change
    add_column :pictures, :email, :string
    add_column :pictures, :message, :string
    remove_column :pictures, :name, :string
  end
end
