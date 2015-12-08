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
      user = context[:current_user]
      ucs = UserCard.includes(:card).
        where(user: user).
        where("due_date <= ?", Date.today)

      deck_ids = UserDeck.where(user: user).map(&:deck_id)

      cards = ucs.map(&:card).select { |c| deck_ids.include? c.deck_id }

      old_cards = cards.select { |uc| uc.created_at != uc.updated_at }
      # Only 10 new cards a day, for moral.
      new_cards = cards.select { |uc| uc.created_at == uc.updated_at }.first(10)

      old_cards.concat(new_cards).tap do |cs|
        cs.each { |c| c.user_id = user.id }
      end
    }
  end

  field :cardsFromDeck do
    type types[CardType]
    argument :deck_id, !types.ID
    resolve -> (object, arguments, context) {
      user = context[:current_user]
      user.cards.where(deck_id: arguments["deck_id"])
    }
  end

  field :decks do
    type types[DeckType]
    resolve -> (object, arguments, context) {
      user = context[:current_user]
      uds = UserDeck.where(user: user)
      uds.map(&:deck)
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
