QueryRoot = GraphQL::ObjectType.define do
  name "Query"
  description "The query root for this schema"

  field :card do
    argument :id, !types.ID
    resolve -> (object, arguments, context) {
      Card.find(arguments["id"])
    }
  end

  field :cards do
    type types[CardType]
    resolve -> (object, arguments, context) {
      Card.all
    }
  end

  field :dueCards do
    type types[CardType]
    resolve -> (object, arguments, context) {
      ucs = UserCard.where("due_date <= ?", Date.today)
      ucs.map(&:card)
    }
  end

  field :cardsFromDeck do
    type types[CardType]
    argument :deck_id, !types.ID
    resolve -> (object, arguments, context) {
      Card.where(arguments["deck_id"])
    }
  end

  field :decks do
    type types[DeckType]
    resolve -> (object, arguments, context) {
      Deck.all
    }
  end

  field :user do
    type UserType
    description "Find a User by id"
    argument :id, !types.ID
    resolve -> (object, arguments, context) {
      User.find(arguments["id"])
    }
  end
end
