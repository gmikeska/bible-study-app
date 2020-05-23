class ChangeGroupsToPages < ActiveRecord::Migration[6.0]
  def change
    rename_table :groups, :pages
  end
end
