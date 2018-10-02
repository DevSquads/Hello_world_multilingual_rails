class AddLanguageToMission < ActiveRecord::Migration[5.2]
  def change
    add_column :missions, :language, :text
  end
end
