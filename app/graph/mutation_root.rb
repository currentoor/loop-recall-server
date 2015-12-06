MutationRoot = GraphQL::ObjectType.define do
  name "Mutation"
  description "The mutation root for this schema"

  field :createCard, CardType do
    argument :deck_id, !types.ID
    argument :question, !types.String
    argument :answer, !types.String
    resolve -> (object, args, context) {
      Card.transaction do
        deck_id, question, answer = [
          args['deck_id'],
          args['question'],
          args['answer']
        ]
        current_user = context[:current_user]

        if UserDeck.find_by(user: current_user, deck_id: deck_id)
          card = Card.create!(
            deck_id: deck_id,
            question: question,
            answer: answer
          )

          all_users = UserDeck.where(deck_id: deck_id)

          all_users.map(&:user).each do |user|
            user.cards << card
          end

          card
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
      user = context[:current_user]

      UserCard.find_by(user: user, card_id: id).card.tap do |card|
        card.question = question if question
        card.answer = answer if answer
        card.deck_id = deck_id if deck_id
        card.save!
      end
    }
  end

  field :answerCard, UserCardType do
    argument :card_id, !types.ID
    argument :response, !types.Int
    resolve -> (object, args, context) {
      card_id, response = [
        args['card_id'],
        args['response']
      ]
      user = context[:current_user]

      uc = UserCard.find_by(card_id: card_id, user: user)
      uc.answer!(response)
      uc
    }
  end

  field :deleteCard, CardType do
    argument :id, !types.ID
    resolve -> (object, args, context) {
      user = context[:current_user]
      id = args['id']

      UserCard.find_by(user: user, card_id: id).card.destroy(user)
    }
  end

  field :createDeck, DeckType do
    # Ex: "mutation bar { createDeck(name: \"clojure\") {id, name} }"
    argument :name, !types.String
    resolve -> (object, args, context) {
      user = context[:current_user]

      Deck.transaction do
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
      user = context[:current_user]

      UserDeck.find_by(deck_id: id, user: user).deck.tap do |deck|
        deck.name = name
        deck.save!
      end
    }
  end

  field :deleteDeck, DeckType do
    # Ex: "mutation bar { deleteDeck(id: \"1\") {id} }"
    argument :id, !types.ID
    resolve -> (object, args, context) {
      user = context[:current_user]
      id = args['id']

      UserDeck.find_by(deck_id: id, user: user).deck.destroy(user)
    }
  end
end
