class CreateInstructions < ActiveRecord::Migration[6.0]
  def change
    create_table :instructions do |t|
      t.string :name        #deprecated |
      t.string :slug        #deprecated | Also added attending(String serialized to Array)
      t.string :description #deprecated |            messages (String serialized to Array)
      t.datetime :occurred  #                        status (string)
      t.integer :course_id
      t.timestamps
    end
  end
end
