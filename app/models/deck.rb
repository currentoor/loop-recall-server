# == Schema Information
#
# Table name: decks
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Deck < ActiveRecord::Base
  has_many :user_decks, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_many :users, through: :user_decks
end
