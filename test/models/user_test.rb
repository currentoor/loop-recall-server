# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  email      :string
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "importing old data" do
    user = User.create(auth0id: 'foobar')

    user.load_old_data(old_data)
    user.reload

    decks = user.decks.count
    deck_cards = user.decks.map(&:cards).map(&:count)
    cards = user.cards.count

    assert_equal 3, decks
    assert_equal [1, 1, 2], deck_cards
    assert_equal 4, cards
  end

  private

  def expected
    [
      {
        "id"=>50, "name"=>"React ",
        "cards" => [
          {
            "due_date"=>"20160117",
            "question"=>"What is data, and what are procedures?",
            "e_factor"=>3,
            "id"=>518,
            "answer"=>"Data isof for manipulating data. ",
            "repetition_count"=>6,
            "decks_id"=>50,
            "interval"=>150
          }
        ]
      },
      {
        "id"=>51, "name"=>"Om ",
        "cards" => [
          {
            "due_date"=>"20160112",
            "question"=>"In eval is itself following what procedure? ",
            "e_factor"=>2.86,
            "id"=>521,
            "answer"=>" Evaluate is the value of the leftmost subexpressio)",
            "repetition_count"=>6,
            "decks_id"=>51,
            "interval"=>129
          },
        ]
      },
      {
        "id"=>49, "name"=>"SICP ",
        "cards" => [
          {
            "due_date"=>"20160112",
            "question"=>"Describe:\nPrimitive expressions\nMeans abstraction",
            "e_factor"=>2.86,
            "id"=>520,
            "answer"=>"Represent and\nBy which and manipulated as units.",
            "repetition_count"=>6,
            "decks_id"=>49,
            "interval"=>129
          },
          {
            "due_date"=>"20160117",
            "question"=>"Explain applicative . Which do lisps use? ",
            "e_factor"=>3,
            "id"=>526,
            "answer"=>"Applicati evaluate thevalues were needed",
            "repetition_count"=>6,
            "decks_id"=>49,
            "interval"=>150
          }
        ]
      },
    ]
  end

  def old_data
    {
      "id"=>27,
      "email"=>"kenbier@gmail.com",
      "decks"=>[
        {"id"=>50, "name"=>"React "},
        {"id"=>51, "name"=>"Om "},
        {"id"=>49, "name"=>"SICP "},
      ],
      "cards"=>[
        {
          "due_date"=>"20160112",
          "question"=>"Describe:\nPrimitive expressions\nMeans abstraction",
          "e_factor"=>2.86,
          "id"=>520,
          "answer"=>"Represent and\nBy which and manipulated as units.",
          "repetition_count"=>6,
          "decks_id"=>49,
          "interval"=>129
        },
        {
          "due_date"=>"20160117",
          "question"=>"Explain applicative . Which do lisps use? ",
          "e_factor"=>3,
          "id"=>526,
          "answer"=>"Applicati evaluate thevalues were needed",
          "repetition_count"=>6,
          "decks_id"=>49,
          "interval"=>150
        },
        {
          "due_date"=>"20160112",
          "question"=>"In eval is itself following what procedure? ",
          "e_factor"=>2.86,
          "id"=>521,
          "answer"=>" Evaluate is the value of the leftmost subexpressio)",
          "repetition_count"=>6,
          "decks_id"=>51,
          "interval"=>129
        },
        {
          "due_date"=>"20160117",
          "question"=>"What is data, and what are procedures?",
          "e_factor"=>3,
          "id"=>518,
          "answer"=>"Data isof for manipulating data. ",
          "repetition_count"=>6,
          "decks_id"=>50,
          "interval"=>150
        }
      ]
    }
  end
end
