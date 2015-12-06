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

  def user_id=(uid)
    @user_id = uid
  end

  def correct_interval
    if @user_id
      uc = UserCard.find_by(user_id: @user_id, card_id: self.id)
      uc.correct_interval
    else
      '???'
    end
  end

  def destroy(user=nil)
    return super() if user.blank?

    ucs = UserCard.where(card: self)

    if ucs.size == 1
      super()
    else
      UserCard.find_by(card: self, user: user).destroy
      self
    end
  end
end
