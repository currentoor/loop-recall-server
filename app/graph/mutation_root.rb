MutationRoot = GraphQL::ObjectType.define do
  name "Mutation"
  description "The mutation root for this schema"

  # field :createUser, UserType do
  #   argument :email, !types.String
  #   argument :password, !types.String
  #   resolve -> (object, args, context) {
  #     User.create(
  #       email: args["email"],
  #       password: args["password"],
  #     )
  #   }
  # end

  field :createCard, CardType do
    argument :user_id, !types.ID
    argument :deck_id, !types.ID
    argument :question, !types.String
    argument :answer, !types.String
    resolve -> (object, args, context) {
      Card.transaction do
        user_id, deck_id, question, answer = [
          args['user_id'],
          args['deck_id'],
          args['question'],
          args['answer']
        ]
        user = User.find(user_id)

        Card.create!(
          deck_id: deck_id,
          question: question,
          answer: answer
        ).tap do |card|
          user.cards << card
        end
      end
    }
  end

  field :updateCard, CardType do
    argument :id, !types.ID
    argument :deck_id, types.ID
    argument :question, types.String
    argument :answer, types.String
    resolve -> (object, args, context) {
      id, deck_id, question, answer = [
        args['id'],
        args['deck_id'],
        args['question'],
        args['answer']
      ]

      Card.find(id).tap do |card|
        card.question = question if question
        card.answer = answer if answer
        card.deck_id = deck_id if deck_id
        card.save!
      end
    }
  end

  field :answerCard, UserCardType do
    argument :card_id, !types.ID
    argument :user_id, !types.ID
    argument :response, !types.Int
    resolve -> (object, args, context) {
      card_id, user_id, response = [
        args['card_id'],
        args['user_id'],
        args['response']
      ]

      uc = UserCard.where(card_id: card_id, user_id: user_id).first
      uc.answer!(response)
      uc
    }
  end

  field :deleteCard, CardType do
    argument :id, !types.ID
    resolve -> (object, args, context) {
      id = args['id']
      Card.find(id).destroy
    }
  end

  field :createDeck, DeckType do
    # Ex: "mutation bar { createDeck(name: \"clojure\" user_id: \"1\") {id, name} }"
    argument :user_id, !types.ID
    argument :name, !types.String
    resolve -> (object, args, context) {
      Deck.transaction do
        user = User.find(args['user_id'])

        Deck.create!(
          name: args['name']
        ).tap do |deck|
          user.decks << deck
        end
      end
    }
  end

  field :updateDeck, DeckType do
    # Ex: "mutation bar { updateDeck(name: \"?????\" id: \"1\") {id, cards{question}} }"
    argument :id, !types.ID
    argument :name, !types.String
    resolve -> (object, args, context) {
      id, name = [
        args['id'],
        args['name']
      ]

      Deck.find(id).tap do |deck|
        deck.name = name
        deck.save!
      end
    }
  end

  field :deleteDeck, DeckType do
    # Ex: "mutation bar { deleteDeck(id: \"1\") {id} }"
    argument :id, !types.ID
    resolve -> (object, args, context) {
      id = args['id']
      Deck.find(id).destroy
    }
  end
end
