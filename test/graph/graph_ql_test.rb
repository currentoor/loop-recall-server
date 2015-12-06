require 'test_helper'

class GraphQlTest < ActiveSupport::TestCase

  setup :initialize_db

  test "should get due cards" do
    result = query "query getDueCards { dueCards {deck_id, question, answer, correct_interval} }"
    expected = {"data"=>
      {"dueCards"=>[
      {"deck_id"=>"#{@ruby.id}",
      "question"=>"a",
      "correct_interval" => "1",
      "answer"=>"a"},
      {"deck_id"=>"#{@ruby.id}",
      "question"=>"b",
      "correct_interval" => "1",
      "answer"=>"b"}
    ]}}

    assert_equal expected, result

    uc = UserCard.where(user: @user, card: @c1).first
    uc.due_date = Date.today + 1
    uc.save!

    result = query "query getDueCards { dueCards {deck_id, question, answer, correct_interval} }"
    expected = {"data"=>
      {"dueCards"=>[{"deck_id"=>"#{@ruby.id}",
      "question"=>"b",
      "correct_interval" => "1",
      "answer"=>"b"}]}}

    assert_equal expected, result
  end

  test "should get decks" do
    result = query "query getDecks { decks {name} }"
    expected = {"data"=>
      {"decks"=>[
        {"name"=>"Ruby"},
        {"name"=>"Clojure"}]}}

    assert_equal expected, result
  end

  test 'should create card' do
    m = "mutation bar { createCard(deck_id: #{@clojure.id},question: \"who?\", answer: \"me!\") {question, answer} }"
    result = mutation m

    expected = {"data"=>{"createCard"=>{"question"=>"who?", "answer"=>"me!"}}}

    assert_equal expected, result
  end

  test 'should update card' do
    m ="mutation bar { updateCard(question: \"?????\", answer: \"!!!!\", id: \"#{@c1.id}\") {question, answer} }"
    result = mutation m

    expected = {"data"=>{"updateCard"=>{"question"=>"?????", "answer"=>"!!!!"}}}

    assert_equal expected, result
  end

  test 'should answer card' do
    m ="mutation bar { answerCard(card_id: \"#{@c1.id}\", response: 5) {due_date_str} }"
    result = mutation m

    expected = {"data"=>{"answerCard"=>{"due_date_str"=>"#{(Date.today+1).to_s}"}}}

    assert_equal expected, result

    result = mutation m

    expected = {"data"=>{"answerCard"=>{"due_date_str"=>"#{(Date.today+6).to_s}"}}}

    assert_equal expected, result
  end

  test 'should delete non-shared card' do
    m = "mutation bar { deleteCard(id: \"#{@c1.id}\") {question, answer} }"
    result = mutation m

    expected = {"data"=>{"deleteCard"=>{"question"=>"a", "answer"=>"a"}}}

    assert_equal expected, result

    result = query "query getUser { user(id: #{@user.id}) { decks{name}, cards{question, answer} } }"
    expected = {"data"=>
      {"user"=>
      {"decks"=>[{"name"=>"Ruby"},
      {"name"=>"Clojure"}],
      "cards"=>[{"question"=>"b",
          "answer"=>"b"}]}}}

    assert_equal expected, result

    assert_raises(ActiveRecord::RecordNotFound) { @c1.reload }
  end

  test 'should not delete shared card' do
    other_user = User.create!(auth0id: 'bar')
    other_user.cards << @c1

    m = "mutation bar { deleteCard(id: \"#{@c1.id}\") {question, answer} }"
    result = mutation m

    expected = {"data"=>{"deleteCard"=>{"question"=>"a", "answer"=>"a"}}}

    assert_equal expected, result

    result = query "query getUser { user(id: #{@user.id}) { decks{name}, cards{question, answer} } }"
    expected = {"data"=>
      {"user"=>
      {"decks"=>[{"name"=>"Ruby"},
      {"name"=>"Clojure"}],
      "cards"=>[{"question"=>"b",
          "answer"=>"b"}]}}}

    assert_equal expected, result

    assert_nothing_raised { @c1.reload }
  end

  test 'should delete non-shared deck' do
    m = "mutation bar { deleteDeck(id: \"#{@ruby.id}\") {name} }"
    result = mutation m

    expected = {"data"=>{"deleteDeck"=>{"name"=>@ruby.name}}}

    assert_equal expected, result

    result = query "query getUser { user(id: #{@user.id}) { decks{name}, cards{question, answer} } }"
    expected = {"data"=>
      {"user"=>
      {"decks"=>[{"name"=>"Clojure"}],
      "cards"=>[]}}}

    assert_equal expected, result

    assert_raises(ActiveRecord::RecordNotFound) { @ruby.reload }
  end

  test 'should not delete shared deck' do
    other_user = User.create!(auth0id: 'bar')
    other_user.decks << @ruby

    m = "mutation bar { deleteDeck(id: \"#{@ruby.id}\") {name} }"
    result = mutation m

    expected = {"data"=>{"deleteDeck"=>{"name"=>@ruby.name}}}

    assert_equal expected, result

    result = query "query getUser { user(id: #{@user.id}) { decks{name}, cards{question, answer} } }"
    expected = {"data"=>
      {"user"=>
      {"decks"=>[{"name"=>"Clojure"}],
      "cards"=>[]}}}

    assert_equal expected, result

    assert_nothing_raised { @ruby.reload }
  end

  private

  def initialize_db
    @user = User.create(auth0id: 'foo')

    @ruby = Deck.create!(name: 'Ruby')
    @clojure = Deck.create!(name: 'Clojure')
    @user.decks << @ruby
    @user.decks << @clojure

    c1_args = {deck: @ruby, question: 'a', answer: 'a'}
    c2_args = {deck: @ruby, question: 'b', answer: 'b'}
    @c1 = Card.create!(c1_args)
    @c2 = Card.create!(c2_args)
    @user.cards << @c1
    @user.cards << @c2

    @user.save!

    @ruby.save!
    @clojure.save!

    @c1.save!
    @c2.save!
  end

  def query(query_string)
    query = GraphQL::Query.new(
      GraphSchema,
      query_string,
      context: {current_user: @user}
    )

    query.result
  end

  def mutation(mutation_string)
    mutation = GraphQL::Query.new(
      GraphSchema,
      mutation_string,
      context: {current_user: @user}
    )

    mutation.result
  end
end
