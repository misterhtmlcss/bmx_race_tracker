class AddUniqueIndexToRacesClubId < ActiveRecord::Migration[8.0]
  def change
    remove_index :races, :club_id
    add_index :races, :club_id, unique: true
  end
end
