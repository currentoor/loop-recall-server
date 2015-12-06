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

  def destroy(user=nil)
    return super() if user.blank?

    uds = UserDeck.where(deck: self)

    if uds.size == 1
      super()
    else
      UserDeck.find_by(deck: self, user: user).destroy
      ucs = UserCard.where(user: user).select { |uc| uc.card.deck.id == self.id }
      ucs.each(&:destroy)
      self
    end
  end
end
