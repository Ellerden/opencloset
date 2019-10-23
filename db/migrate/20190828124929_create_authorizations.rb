class CreateAuthorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :authorizations do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :username
      t.string :city
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :linked_email
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :confirmation_token

      t.timestamps
    end

    add_index :authorizations, [:provider, :uid]
    add_index(:authorizations, [:provider, :uid, :linked_email], unique: true)
  end
end
