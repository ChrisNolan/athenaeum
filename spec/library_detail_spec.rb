require 'minitest/autorun'
require_relative "../lib/library_detail.rb"

describe LibraryDetail do

	describe 'retrieves detail from library website' do
	
		it "retrieves a page with the library id" do
			skip "Until we mock up the web request"
			library_detail = LibraryDetail.retrieve("121457")
			library_detail.library_id.must_equal "121457"
			library_detail.page.wont_be_nil
		end
		it "parses ISBNs from the page" do
			library_detail = LibraryDetail.retrieve_stub("121457")
			library_detail.isbn.must_equal "9780152744281"
		end
		it "parses ISBNs from the page and details with extraneous text" do
			library_detail = LibraryDetail.retrieve_stub("2818214")
			library_detail.isbn.must_equal "9781934964668"
		end
		it "parses ISBN when there is only one listed and it has leading zero" do
			library_detail = LibraryDetail.retrieve_stub("549885")
			library_detail.isbn.must_equal "0690044968"
		end
		it "parses ISBN when there is only one listed" do
			library_detail = LibraryDetail.retrieve_stub("121429")
			library_detail.isbn.must_equal "9780091884895"
		end
		describe "when library detail has multiple ISBNs list" do
			it "picks the ISBN that has no extra text" do # The Ruby way
				library_detail = LibraryDetail.retrieve_stub("275212")
				library_detail.isbns.size.must_equal 3
				library_detail.isbn.must_equal "9780672328848"
			end
			it "picks the last ISBN from the list and makes sure it doesn't have any text in it" do # The Ruby way
				library_detail = LibraryDetail.retrieve_stub("2403521")
				library_detail.isbns.size.must_equal 4
				library_detail.isbn.must_equal "9780060772901"
			end
			it "doesn't strip leading 0s from ISBN-10s" do
				library_detail = LibraryDetail.retrieve_stub("542862")
				library_detail.isbns.size.must_equal 2
				library_detail.isbn.must_equal "0060295945"

			end
		end
		describe "handles document parsing errors" do
			# here are some library ids are failing to parse tr.isbn from the page: 121429 219833 121429 123720 1747068         
			it "can get the input#recordID" do
				library_detail = LibraryDetail.retrieve_stub("219833")
				#library_detail.page.errors.size.must_equal 'Frank'
				library_detail.page.css('input#recordId').first.attributes['value'].text.must_equal "219833"	 # this is the 3rd element within body, and it's not parsed
				#library_detail.page.css('form#searchForm').size.must_equal 0
			end
		end
		describe "subject headings" do
			it "returns empty when no subject headings listed"
			it "returns single item when only one subject heading" do # 121457
				library_detail = LibraryDetail.retrieve_stub("121457")
				library_detail.subjects.must_equal ["Humorous stories"]
			end
			it "returns array of subject headings" do # 549885
				library_detail = LibraryDetail.retrieve_stub("549885")
				library_detail.subjects.size.must_equal 4
				library_detail.subjects.must_include "Books"
			end
			it "returns array of subject headings split with the --" do # 2403521
				library_detail = LibraryDetail.retrieve_stub("2403521")
				library_detail.subjects.size.must_equal 4
				library_detail.subjects.must_include "Jazz"
				library_detail.subjects.must_include "Juvenile fiction"
			end
		end
	end
	
end