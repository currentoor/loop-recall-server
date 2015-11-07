DeckType = GraphQL::ObjectType.define do
  name "Deck"

  field :id, !types.ID
  field :name, !types.String
  field :users, -> { !types[!UserType] }
  field :cards, -> { !types[!CardType] }
end
