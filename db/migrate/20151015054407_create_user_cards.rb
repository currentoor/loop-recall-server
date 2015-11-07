class CreateUserCards < ActiveRecord::Migration
  def change
    create_table :user_cards do |t|
      t.references :user, index: true, foreign_key: true
      t.references :card, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
