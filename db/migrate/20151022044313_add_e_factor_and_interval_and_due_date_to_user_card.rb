class AddEFactorAndIntervalAndDueDateToUserCard < ActiveRecord::Migration
  def change
    add_column :user_cards, :e_factor, :decimal
    add_column :user_cards, :interval, :integer
    add_column :user_cards, :due_date, :date
  end
end
