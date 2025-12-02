class CreateUserProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :user_profiles do |t|
      t.text :goal
      t.text :starting_lvl
      t.text :equipment
      t.integer :sessions_per_week
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
