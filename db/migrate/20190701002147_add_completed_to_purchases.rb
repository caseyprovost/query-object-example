class AddCompletedToPurchases < ActiveRecord::Migration[5.2]
  def change
    add_column :purchases, :completed, :boolean, null: false, default: false
  end
end
