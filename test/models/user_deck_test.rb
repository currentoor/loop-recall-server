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

require 'test_helper'

class UserDeckTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
