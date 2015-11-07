CardType = GraphQL::ObjectType.define do
  name "Card"

  field :id, !types.ID
  field :deck_id, !types.ID
  field :question, !types.String
  field :answer, !types.String
  field :deck, !DeckType
end
