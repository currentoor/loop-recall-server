# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  has_many :user_cards, dependent: :destroy
  has_many :user_decks, dependent: :destroy
  has_many :cards, through: :user_cards, dependent: :destroy
  has_many :decks, through: :user_decks, dependent: :destroy
end
