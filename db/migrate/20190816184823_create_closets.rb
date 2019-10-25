class CreateClosets < ActiveRecord::Migration[5.2]
  def change
    create_table :closets do |t|
      t.string :name, null: false
      t.boolean :open, null: false, default: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
