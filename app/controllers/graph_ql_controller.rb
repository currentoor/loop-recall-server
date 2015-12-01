class GraphQlController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :authenticate, except: [:index]

  def query
    query_string = params[:query]
    query = GraphQL::Query.new(
      GraphSchema,
      query_string,
      context: {current_user: current_user}
    )

    render transit: query.result
  end

  def mutation
    mutation_string = params[:mutation]
    mutation = GraphQL::Query.new(
      GraphSchema,
      mutation_string,
      context: {current_user: current_user}
    )

    render transit: mutation.result
  end

  def index
  end
end

