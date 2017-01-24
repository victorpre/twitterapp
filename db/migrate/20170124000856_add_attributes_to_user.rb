class AddAttributesToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string, null: false, default: ""
    add_column :users, :phone_number, :string, null: false, default: ""
    add_column :users, :profile_img_url, :string, null: false, default: ""
    add_column :users, :address, :string, null: false, default: ""
    add_column :users, :city, :string, null: false, default: ""
    add_column :users, :state, :string, null: false, default: ""
    add_column :users, :country, :string, null: false, default: ""
  end
end
