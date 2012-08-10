require 'minitest/autorun'
require_relative "../lib/goodreads.rb"

describe Goodreads do
	describe "book data" do
		describe "isbn to id" do
			it "returns book id from isbn" do
				skip "until we can webmock"
				Goodreads.book_isbn_to_id("9780672328848").must_equal "4514"
			end
			it "handles an invalid isbn"
		end
	end
	describe "access token" do
		it "has one" do
			goodreads = Goodreads.new
			goodreads.access_token.wont_be_nil
		end
	end
	describe "shelves" do
		describe "shelf list" do
			it "gets a list of shelfs" do
				goodreads = Goodreads.new
				shelf_list = goodreads.shelf_list
				shelf_list.must_be_kind_of Hash
				shelf_list = goodreads.shelf_list
				shelf_list.must_be_kind_of Hash
			end
			it "provides a list of the shelf names" do
				goodreads = Goodreads.new
				shelf_names = goodreads.shelf_names
				shelf_names.must_include "read"
			end
		end
		describe "shelf names by book" do
			it "gets a list of shelfs a book id is on" do
				goodreads = Goodreads.new
				shelves = goodreads.shelf_names_by_book("285679")
				shelves.must_include "read"
				shelves.must_include "read-aloud"
			end
			it "gets a blank list for a book we haven't reviewed" do
				goodreads = Goodreads.new
				goodreads.shelf_names_by_book("285678").must_be_empty
			end
		end
		describe "adding shelves" do
			it "adds a shelf" do
				skip "until I can mock it up better"
				goodreads = Goodreads.new
				goodreads.shelf_names.wont_include "testshelf"
				goodreads.add_shelf "testshelf"
				goodreads.shelf_names.must_include "testshelf"
				# TODO delete the testshelf
			end
			it "adds required shelfs" do
				skip "until I can mock it up better"
				goodreads = Goodreads.new
				goodreads.shelf_names.wont_include "test-required-shelf-1"
				goodreads.shelf_names.must_include "test-required-shelf-2" # I've set this shelf up manually
				goodreads.required_shelves %w(test-required-shelf-1 test-required-shelf-2 test-required-shelf-3)
				goodreads.shelf_names.must_include 'test-required-shelf-1'
				goodreads.shelf_names.must_include 'test-required-shelf-3'
				# TODO delete the created test shelves
			end
		end
		describe "add book to shelf" do
			it "adds a book to the given shelf" do
				skip "so I don't hit the api when running my test for now"
				goodreads = Goodreads.new
				goodreads.add_to_shelf("test-required-shelf-2", "4514")
				# TODO actually confirm the given book is on that shelf -- for now I'm just looking on the website
			end
			it "adds a book to all the given shelves" do
				skip "so I don't hit the api when running tests for now"
				goodreads = Goodreads.new
				goodreads.add_to_shelf(["ruby", "ruby (computer programming language)", "athenaeum-test"], "4514")
				shelves = goodreads.shelf_names_by_book("4514")
				shelves.must_include "athenaeum-test"
				shelves.must_include "ruby-computer-programming-language"
			end
		end
	end
end