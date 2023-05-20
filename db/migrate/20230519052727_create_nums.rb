class CreateNums < ActiveRecord::Migration[7.0]
  def change
    create_table :nums do |t|
      t.integer :value

      t.timestamps
    end
  end
end
