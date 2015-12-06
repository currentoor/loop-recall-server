# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  email      :string
#

class User < ActiveRecord::Base
  has_many :user_cards, dependent: :destroy
  has_many :user_decks, dependent: :destroy
  has_many :cards, through: :user_cards, dependent: :destroy
  has_many :decks, through: :user_decks, dependent: :destroy

  validates :auth0id, presence: true

  def load_sample_data
    sample_decks.each do |deck_data|
      deck = Deck.create!(name: deck_data[:name])
      self.decks << deck

      deck_data[:cards].each do |card_data|
        card = Card.create!(
          deck_id: deck.id,
          question: card_data['question'],
          answer: card_data['answer']
        )
        self.cards << card
      end
    end
  end

  def sample_decks
    [clojure_deck, punjabi_deck, urdu_deck, ruby_deck, hindi_deck]
  end

  def urdu_deck
    {name: 'Urdu', cards:
    [{"answer"=>"vaze taur pr dekhen ge, will see clearly", "question"=>"واضح طور پر دیکھیں گے"},
    {"answer"=>"zor se hns pde, laughed out loud", "question"=>" زور سے ہنس پڑے"}]}
  end

  def ruby_deck
    {name: 'Ruby', cards:
    [
      {"answer"=>
        "*Private* methods can only be called on an implicit receiver whereas *protected* methods can only be called in the scope of any object belonging to the same class as the receiver.\n```ruby\nclass Person\n  def older_than?(other_person)\n    age > other_person.age\n  end\n\n  protected\n\n  def age\n    @age\n  end\nend\n```",
      "question"=>"What is the difference between *private* and *protected* methods?"},
        {"answer"=>
          "The superclass-copy of `B` keeps track of what objects get added directly to `B`. So yes if the methods are added to `B` but not if they are added indirectly (e.g. in a module that was included in `B`).",
        "question"=>"If `class A` includes `module B` and a new method `foo` is included in `B` after `B`'s inclusion in `A` then is `foo` available in `A`?"},
     ]
    }
  end

  def clojure_deck
    {name: 'Clojure', cards:
    [{"answer"=>
      "A macro for implementing a protocol, good for when you want to inline the protocol function definitions.\n```clojure\n(defrecord Banana [qty])\n;;; 'subtotal' differ from each fruit.\n(defprotocol Fruit\n  (subtotal [item]))\n(extend-type Banana\n  Fruit\n  (subtotal [item]\n    (* 158 (:qty item))))\n```",
    "question"=>"What is `extend-type` and when is it useful over `extend`?"},
      {"answer"=>
        "Same for `->>`\n```clojure\n(cond-> 1          ; we start with 1\n    true inc       ; the condition is true so (inc 1) => 2\n    false (* 42)   ; condition is false so skipped\n    (= 2 2) (* 3)) ; (= 2 2) is true so (* 2 3) => 6 \n;;=> 6\n```",
      "question"=>"How should you thread, `->`/`->>`, an expression through the forms of a `cond`?"},
      {"answer"=>
        "They bundle operation and case discrimination together. It's easy to add new operation on existing types but it's hard to add new types over existing behavior. Usually requires adding to a `case` statement in the target operation.",
      "question"=>"Why does functional programming come up short against the expression problem?"}]
    }
  end

  def hindi_deck
    {name: 'Hindi', cards:
    [{"answer"=>"surprise party ki yojna bnai, made a plan for a surprise party", "question"=>"सरप्राइज़ पार्टी की योजना बनाई"},
    {"answer"=>"lad piya se bigadna, to spoil by pampering", "question"=>"लाड़-प्यार से बिगाड़ना"}]
    }
  end

  def punjabi_deck
    {name: 'Punjabi', cards:
    [{"answer"=>"viakrn, grammar", "question"=>"ਵਿਆਕਰਣ"},
    {"answer"=>"anuvadk, translator", "question"=>"ਅਨੁਵਾਦਕ"}]
    }
  end
end
