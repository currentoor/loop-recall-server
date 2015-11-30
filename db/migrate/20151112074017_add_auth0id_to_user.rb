class AddAuth0idToUser < ActiveRecord::Migration
  def change
    add_column :users, :auth0id, :string
  end
end
