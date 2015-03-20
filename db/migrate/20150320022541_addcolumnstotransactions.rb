class Addcolumnstotransactions < ActiveRecord::Migration
  def up
    remove_column :transactions, :info
    add_column :transactions, :type, :string
    add_column :transactions, :name, :string
    add_column :transactions, :city, :string
    add_column :transactions, :state, :string
  end

  def down
    add_column :transactions, :info, :string
    remove_column :transactions, :type
    remove_column :transactions, :name
    remove_column :transactions, :city
    remove_column :transactions, :state
  end
end
