# == Schema Information
#
# Table name: cards
#
#  id         :integer          not null, primary key
#  question   :text
#  answer     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deck_id    :integer
#

class Card < ActiveRecord::Base
  belongs_to :deck
  has_many :user_cards, dependent: :destroy
  has_many :users, through: :user_cards
end
