require 'minitest/autorun'
require_relative "../lib/your_account.rb"

describe YourAccount do
	describe "http stuff" do
		# TODO If you are making HTTP calls in your code also checkout [[https://github.com/bblimke/webmock|WebMock]] and [[https://github.com/myronmarston/vcr|VCR]] for some great ways to mock and stub HTTP services.
		it "can connect to the library website" do
			skip "so we're not hitting the web each time" # !!!
			your_account = YourAccount.new
			response = your_account.connect
			response.cookies.must_include "JSESSIONID"
		end
		
		it "can retrieve the 'youraccount' page" do
			skip "so we're not hitting the web each time" # !!!
			your_account = YourAccount.new
			page = your_account.retrieve
			page.css('title')[0].to_str.must_equal "Toronto Public Library Your Account"
		end
		
		it "can pass in the credentials" do
			your_account = YourAccount.new("card #","password")
			your_account.library_card.must_equal "card #"
			your_account.library_password.must_equal "password"
		end
	end
	
	describe "checked out items" do
	
		let(:your_account) {
			x = YourAccount.new
			x.retrieve_stub
			x
		}
		
		it "can parse the checked out items to an array" do
			your_account.checked_out.size.must_equal 9
		end
		
		it "can handle a DVD format in the first row" do
			your_account.checked_out.first.local_format.must_equal 'DVD'
		end
		
		it "can renew selected items"
	end
	
	it "can parse the on hold items"
	it "can parse the ready for pickup items"
	it "can parse the in transit items"
end