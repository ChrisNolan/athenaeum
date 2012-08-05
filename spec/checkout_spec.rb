require 'minitest/autorun'
require_relative "../lib/checkout.rb"

describe Checkout do

	describe "Attributes" do
	
		subject { Checkout.new("The Ruby Way", "275212", "Book", 1, Date.new(2007,1,23)) }
		
		# these are more unit test stuff than spec stuff, no?
		it "has a title" do
			subject.title.must_equal "The Ruby Way"
		end
		it "has a library id" do
			subject.library_id.must_equal "275212"
		end
		it "has an href" do
			subject.href.must_equal "http://www.torontopubliclibrary.ca/detail.jsp?R=275212"
		end
		it "has a local format" do
			subject.local_format.must_equal "Book"
		end
		it "has a renew count" do
			subject.renew_count.must_equal 1
		end
		it "has a due date" do
			subject.due_date.to_s.must_equal Date.new(2007,1,23).to_s
		end
		it "has a status"
		it "assigns the library id from the href" do
			subject.href="http://www.torontopubliclibrary.ca/detail.jsp?R=212572"
			subject.library_id.must_equal "212572"
		end
	end
	
	describe "can parse itself from html" do
		before do
			row = Nokogiri::HTML(open("spec/pages/checked_out_tr.html"))
			@checkout = Checkout.parse_from_html(row)
		end
		
		it "has a title" do
			@checkout.title.must_equal "Making things move : DIY mechanisms for inventors, hobbyists, and artists"
		end
		it "has a library id" do
			@checkout.library_id.must_equal "2719201"
		end
		it "has a local format" do
			@checkout.local_format.must_equal "Book"
		end
		it "has the renew count"
		it "has the renew date"
		it "has unparsed extra detail" do
			@checkout.unparsed_extra_detail.must_equal "RENEW^37131121201545^621.8 ROB^1^Roberts, Dustyn.^Making things move : DIY mechanisms for inventors, hobbyists, and artists^"
		end
	end
	
end