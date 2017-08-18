class CreateBwrows < ActiveRecord::Migration[5.1]
  def change
    create_table :bwrows do |t|
      t.string :row

      t.timestamps
    end
  end
end
