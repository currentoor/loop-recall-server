class CreateUserDecks < ActiveRecord::Migration
  def change
    create_table :user_decks do |t|
      t.references :user, index: true, foreign_key: true
      t.references :deck, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
