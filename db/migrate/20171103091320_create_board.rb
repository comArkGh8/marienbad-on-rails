class CreateBoard < ActiveRecord::Migration[5.1]
  def change
    create_table :boards do |t|
      t.integer :turn
      t.integer :row_one
      t.integer :row_two
      t.integer :row_three
      t.integer :row_four
    end
  end
end
