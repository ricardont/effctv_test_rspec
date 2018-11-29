require_relative '../../../app/api'
require 'rack/test'
module ExpenseTracker 
	RecordResult = Struct.new(:sucess?, :expense_id, :error_message)
	RSpec.describe API  do 
		include Rack::Test::Methods
		def app
			API.new(ledger: ledger)
		end
		let(:ledger) { instance_double('ExpenseTracker:Ledger') }

		describe 'POST/expenses' do

			context 'When the expense is succesfully recorded' do
				expense = {'some' => 'data'}
			  before do
					allow(ledger).to receive(:record).with(expense).and_return(RecordResult.new(true, 417, nil))
					post '/expenses', JSON.generate(expense)
			  end
				it 'returns expense id' do
					parsed = JSON.parse(last_response.body)
					expect(parsed).to include('expense_id' => 417)
				end
					
				it 'Respond with  200' do
					expect(last_response.status).to eq(200)
				end
			end	
			context 'when the expense fail validation' do
				expense = {'some' => 'data'}
			  before do
					allow(ledger).to receive(:record).with(expense).and_return(RecordResult.new(false, 422, 'expense incomplete'))
					post '/expenses', JSON.generate(expense)
			  end
				it 'returns an error message' do
					parsed = JSON.parse(last_response.body)
					expect(parsed).to include('error_message' => 'expense incomplete')
				end
				it 'returns with  422' do
					expect(last_response.status).to eq(422)
				end
			end
		end
	end
		
end	