require 'rack/test'
require 'json'
require_relative '../../app/api'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API' do
    include Rack::Test::Methods

    def app
      ExpenseTracker::API.new
    end

    def post_expense(expense)
      post '/expenses', JSON.generate(expense)
      expect(last_response.status).to eq(200)

      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id' => an_instance_of(Integer))
      expense.merge('id' => parsed['expense_id'])
    end

    it 'records the submitted expenses' do
      pending 'Need to persist expenses'
      coffee = post_expense(
          'payee' => 'Starbucks',
          'amount' => 5.75,
          'date' => '2017-04-01'
      )

      zoo = post_expense(
          'payee' => 'Zoo',
          'amount' => 15.75,
          'date' => '2017-04-01'
      )

      groceries = post_expense(
          'payee' => 'Green Vegetables',
          'amount' => 25.75,
          'date' => '2017-04-02'
      )

      get '/expenses/2017-04-01'
      expect(last_response.status).to eq(200)
      expenses = JSON.parse(last_response.body)
      expect(expenses).to contain_exactly(coffee, zoo)
    end
  end
end