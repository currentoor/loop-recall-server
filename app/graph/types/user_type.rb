UserType = GraphQL::ObjectType.define do
  name "User"
  description "A particular user."

  field :id, !types.ID
  field :cards, -> { !types[!CardType] }
  field :decks, -> { !types[!DeckType] }
end

