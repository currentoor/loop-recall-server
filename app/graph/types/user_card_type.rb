UserCardType = GraphQL::ObjectType.define do
  name "UserCard"

  field :id, !types.ID
  field :user_id, !types.ID
  field :card_id, !types.ID
  field :due_date_str, !types.String
end
