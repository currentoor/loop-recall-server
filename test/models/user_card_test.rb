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

require 'test_helper'

class UserCardTest < ActiveSupport::TestCase
  test "the sm2 inital values" do
    uc = UserCard.new
    assert_equal 2.5, uc.e_factor
    assert_equal 1, uc.interval
    assert_equal Date.today, uc.due_date
    assert_equal 1, uc.repetition
  end

  test "answering correctly" do
    uc = UserCard.new

    uc.answer!(5)

    assert_equal 2.6, uc.e_factor
    assert_equal 6, uc.interval
    assert_equal Date.today + 6, uc.due_date
    assert_equal 2, uc.repetition

    uc.answer!(5)

    assert_equal 2.7, uc.e_factor
    assert_equal 16, uc.interval
    assert_equal Date.today + 16, uc.due_date
    assert_equal 3, uc.repetition

    uc.answer!(5)

    assert_equal 2.8, uc.e_factor
    assert_equal 44, uc.interval
    assert_equal Date.today + 44, uc.due_date
    assert_equal 4, uc.repetition
  end

  test "answering correctly with hesitation" do
    uc = UserCard.new

    uc.answer!(3)

    assert_equal 2.36, uc.e_factor
    assert_equal 6, uc.interval
    assert_equal Date.today + 6, uc.due_date
    assert_equal 2, uc.repetition

    uc.answer!(3)

    assert_equal 2.22, uc.e_factor
    assert_equal 15, uc.interval
    assert_equal Date.today + 15, uc.due_date
    assert_equal 3, uc.repetition

    uc.answer!(3)

    assert_equal 2.08, uc.e_factor
    assert_equal 34, uc.interval
    assert_equal Date.today + 34, uc.due_date
    assert_equal 4, uc.repetition
  end

  test "answering incorrectly, correctly, incorrectly, then correctly" do
    uc = UserCard.new
    uc.answer!(0)

    assert_equal 2.5, uc.e_factor
    assert_equal 1, uc.interval
    assert_equal Date.today + 1, uc.due_date
    assert_equal 1, uc.repetition

    uc.answer!(5)
    uc.answer!(5)

    assert_equal 2.7, uc.e_factor
    assert_equal 16, uc.interval
    assert_equal Date.today + 16, uc.due_date
    assert_equal 3, uc.repetition

    uc.answer!(0)

    assert_equal 2.7, uc.e_factor
    assert_equal 1, uc.interval
    assert_equal Date.today + 1, uc.due_date
    assert_equal 1, uc.repetition

    uc.answer!(5)
    uc.answer!(5)

    assert_equal 2.9, uc.e_factor
    assert_equal 17, uc.interval
    assert_equal Date.today + 17, uc.due_date
    assert_equal 3, uc.repetition
  end
end
