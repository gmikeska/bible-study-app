class AddComponentsToPages < ActiveRecord::Migration[6.0]
  def change
    add_column :pages, :components, :string
  end
end
