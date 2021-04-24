class ChangeCustomersRemoveAddressCityStateZip < ActiveRecord::Migration[5.2]
  def change
    remove_column :customers, :address, :string
    remove_column :customers, :city, :string
    remove_column :customers, :state, :string
    remove_column :customers, :zip, :bigint
  end
end
