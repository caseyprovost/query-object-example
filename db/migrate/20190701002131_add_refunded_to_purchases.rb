class AddRefundedToPurchases < ActiveRecord::Migration[5.2]
  def change
    add_column :purchases, :refunded, :boolean, null: false, default: false
  end
end
