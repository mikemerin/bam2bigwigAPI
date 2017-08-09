class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :string
      t.integer :alignment_id

      t.timestamps
    end
  end
end
