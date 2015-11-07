# == Schema Information
#
# Table name: user_cards
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  card_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  e_factor   :decimal(, )
#  interval   :integer
#  due_date   :date
#  repetition :integer
#

class UserCard < ActiveRecord::Base
  belongs_to :user
  belongs_to :card
  after_initialize :sm2_defaults

  def self.reset!(user_id)
    ucs = UserCard.where(user_id: user_id)
    ucs.each do |uc|
      uc.due_date = Date.today
      uc.save!
    end
  end

  def sm2_defaults
    self.e_factor = 2.5
    self.interval = 1
    self.due_date = Date.today
    self.repetition = 1
  end

  def due_date_str
    self.due_date.to_s
  end

  def answer!(response)
    resp = response.to_i
    if resp < 3
      self.repetition = 1
      self.interval = 1
      self.due_date = Date.today + 1
    else
      self.interval = new_interval(self.repetition+1, self.interval, self.e_factor)
      self.due_date = Date.today + self.interval
      self.repetition += 1
      self.e_factor = new_e_factor(self.e_factor, resp)
    end

    self.save!
  end

  private

  def new_e_factor(old_ef, q)
    computed = old_ef + (0.1-(5-q)*(0.08+(5-q)*0.02))

    if computed < 1.3
      1.3
    else
      computed
    end
  end

  def new_interval(rep, old_interval, ef)
    if rep == 1
      1
    elsif rep == 2
      6
    else
      (old_interval * ef).ceil
    end
  end
end
