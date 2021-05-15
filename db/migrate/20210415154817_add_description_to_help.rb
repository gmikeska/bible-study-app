class AddDescriptionToHelp < ActiveRecord::Migration[6.0]
  def change
    add_column :helps, :description, :string
  end
end
