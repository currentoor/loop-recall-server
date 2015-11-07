require 'test_helper'

class GraphQlControllerTest < ActionController::TestCase

  setup :initialize_db

  test "should get a user specified data" do
    get :query, query: "query getUser { user(id: #{@user.id}) { decks{name}, cards{question, answer} } }"
    expected = {"data"=>
      {"user"=>
      {"decks"=>[{"name"=>"Ruby"},
      {"name"=>"Clojure"}],
      "cards"=>[{"question"=>"a",
        "answer"=>"a"},
        {"question"=>"b",
          "answer"=>"b"}]}}}

    reader = Transit::Reader.new(:json, StringIO.new(@response.body))
    assert_equal expected, reader.read
  end

  test "should get due cards" do
    get :query, query: "query getDueCards { dueCards {deck_id, question, answer} }"
    expected = {"data"=>
      {"dueCards"=>[
      {"deck_id"=>"#{@ruby.id}",
      "question"=>"a",
      "answer"=>"a"},
      {"deck_id"=>"#{@ruby.id}",
      "question"=>"b",
      "answer"=>"b"}
    ]}}

    reader = Transit::Reader.new(:json, StringIO.new(@response.body))
    assert_equal expected, reader.read

    uc = UserCard.where(user: @user, card: @c1).first
    uc.due_date = Date.today + 1
    uc.save!

    get :query, query: "query getDueCards { dueCards {deck_id, question, answer} }"
    expected = {"data"=>
      {"dueCards"=>[{"deck_id"=>"#{@ruby.id}",
      "question"=>"b",
      "answer"=>"b"}]}}

    reader = Transit::Reader.new(:json, StringIO.new(@response.body))
    assert_equal expected, reader.read
  end

  test "should get cards" do
    get :query, query: "query getCards { cards {question, answer} }"
    expected = {"data"=>
      {"cards"=>[{"question"=>"MyText",
      "answer"=>"MyText"},
      {"question"=>"MyText",
        "answer"=>"MyText"},
      {"question"=>"a",
        "answer"=>"a"},
      {"question"=>"b",
        "answer"=>"b"}]}}

    reader = Transit::Reader.new(:json, StringIO.new(@response.body))
    assert_equal expected, reader.read
  end

  test "should get decks" do
    get :query, query: "query getDecks { decks {name} }"
    expected = {"data"=>
      {"decks"=>[{"name"=>"MyString"},
        {"name"=>"MyString"},
        {"name"=>"Ruby"},
        {"name"=>"Clojure"}]}}

    reader = Transit::Reader.new(:json, StringIO.new(@response.body))
    assert_equal expected, reader.read
  end

  test 'should create card' do
    m = "mutation bar { createCard(deck_id: #{@clojure.id},question: \"who?\", answer: \"me!\", user_id: \"#{@user.id}\") {question, answer} }"
    post :mutation, mutation: m

    expected = {"data"=>{"createCard"=>{"question"=>"who?", "answer"=>"me!"}}}

    reader = Transit::Reader.new(:json, StringIO.new(@response.body))
    assert_equal expected, reader.read
  end

  test 'should update card' do
    m ="mutation bar { updateCard(question: \"?????\", answer: \"!!!!\", id: \"#{@c1.id}\") {question, answer} }"
    post :mutation, mutation: m

    expected = {"data"=>{"updateCard"=>{"question"=>"?????", "answer"=>"!!!!"}}}

    reader = Transit::Reader.new(:json, StringIO.new(@response.body))
    assert_equal expected, reader.read
  end

  test 'should answer card' do
    m ="mutation bar { answerCard(card_id: \"#{@c1.id}\", user_id: \"#{@user.id}\", response: 5) {due_date_str} }"
    post :mutation, mutation: m

    expected = {"data"=>{"answerCard"=>{"due_date_str"=>"#{(Date.today+6).to_s}"}}}

    reader = Transit::Reader.new(:json, StringIO.new(@response.body))
    assert_equal expected, reader.read
  end

  test 'should delete card' do
    m = "mutation bar { deleteCard(id: \"#{@c1.id}\") {question, answer} }"
    post :mutation, mutation: m

    expected = {"data"=>{"deleteCard"=>{"question"=>"a", "answer"=>"a"}}}

    reader = Transit::Reader.new(:json, StringIO.new(@response.body))
    assert_equal expected, reader.read

    get :query, query: "query getUser { user(id: #{@user.id}) { decks{name}, cards{question, answer} } }"
    expected = {"data"=>
      {"user"=>
      {"decks"=>[{"name"=>"Ruby"},
      {"name"=>"Clojure"}],
      "cards"=>[{"question"=>"b",
          "answer"=>"b"}]}}}

    reader = Transit::Reader.new(:json, StringIO.new(@response.body))
    assert_equal expected, reader.read
  end

  private

  def initialize_db
    @user = User.create

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

end
