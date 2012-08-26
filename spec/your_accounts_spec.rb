require 'minitest/autorun'
require_relative "../lib/your_accounts.rb"

describe YourAccounts do
	
	describe 'initialize' do
		it 'handles a single card/pass passed to it' do
			your_accounts = YourAccounts.new("card #","password")
			your_accounts.library_cards.first.must_equal "card #"
			your_accounts.library_passwords.last.must_equal "password"
			your_accounts.accounts.size.must_equal 1
		end
		it 'handles multiple cards/passwords passed to it' do
			your_accounts = YourAccounts.new("card #1, card #2","first password, second password")
			your_accounts.library_cards.first.must_equal "card #1"
			your_accounts.library_passwords.last.must_equal "second password"
			your_accounts.accounts.size.must_equal 2
		end
		it 'handles a single card in the config file'
		it 'handles multiple cards in the config file'
		it 'errors appropriately with no cards in the config file'
		it 'errors appropriately with no config file'
	end
	
	describe 'checked_out' do
		it 'returns a list of checked out items across all cards' do
			skip # until I can mock the retrieve properly -- otherwise un skip and edit the .tpl file to give different accounts
			your_accounts = YourAccounts.new
			your_accounts.checked_out.size.must_equal 30
		end
	end
	
end