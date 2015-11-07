# == Schema Information
#
# Table name: user_decks
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  deck_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserDeck < ActiveRecord::Base
  belongs_to :user
  belongs_to :deck
end
