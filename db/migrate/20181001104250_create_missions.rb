class CreateMissions < ActiveRecord::Migration[5.2]
  def change
    create_table :missions do |t|
      t.string :title
      t.string :instructions
      t.integer :duration
      t.string :category
      t.string :language

      t.timestamps
    end
  end
end
