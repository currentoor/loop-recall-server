class AddRepetitionToUserCard < ActiveRecord::Migration
  def change
    add_column :user_cards, :repetition, :integer
  end
end
