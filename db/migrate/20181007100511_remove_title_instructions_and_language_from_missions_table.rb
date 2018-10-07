class RemoveTitleInstructionsAndLanguageFromMissionsTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :missions, :title, :string
    remove_column :missions, :instructions, :string
    remove_column :missions, :language, :text
  end
end
