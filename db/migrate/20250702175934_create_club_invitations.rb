class CreateClubInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :club_invitations do |t|
      t.references :club, null: false, foreign_key: true
      t.string :email, null: false
      t.string :token, null: false
      t.integer :status, default: 0, null: false
      t.references :invited_by, polymorphic: true, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :club_invitations, :token, unique: true
    add_index :club_invitations, [ :email, :club_id ]
  end
end
