class CreateRaces < ActiveRecord::Migration[8.0]
  def change
    create_table :races do |t|
      t.references :club, null: false, foreign_key: true
      t.integer :gate_counter
      t.integer :staging_counter
      t.time :registration_deadline
      t.time :race_start_time

      t.timestamps
    end
  end
end
