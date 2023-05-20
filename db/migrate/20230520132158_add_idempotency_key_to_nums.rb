class AddIdempotencyKeyToNums < ActiveRecord::Migration[7.0]
  def change
    add_column :nums, :idempotency_key, :string
    add_index :nums, :idempotency_key, unique: true
  end
end
