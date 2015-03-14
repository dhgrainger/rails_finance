class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.date :date
      t.integer :amount
      t.text :info
      t.timestamps
    end
  end
end
