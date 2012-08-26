require "date"
require "nokogiri"

class Checkout
	attr_accessor :title, :library_id, :local_format, :renew_count, :due_date, :unparsed_extra_detail
	
	def initialize(title, library_id="", local_format="", renew_count=0, due_date=nil)
		@title = title
		@library_id = library_id
		@local_format = local_format
		@renew_count = renew_count
		@due_date = due_date
		raise "Title not a string" unless @title.kind_of?(String)
	end
	
	def href
		"http://www.torontopubliclibrary.ca/detail.jsp?R=#{@library_id}"
	end
	
	def href=(x)
		left, right = x.split("?R=")
		@library_id = right if right
	end
	
	def checked_out_date
		# lots of assumptions -- 21 days per check out, and renewed on the date it was due
		due_date - ((renew_count+1)*21)
	end
	
	def self.parse_from_html(row)
		columns = row.css "td"
		input_field = columns[0] % "input"
		unparsed_extra_detail = input_field.attributes["name"].value
		title_field = columns[1] % "a"
		if title_field # some checked out items don't have a link -- e.g. BOARD BOOKS / NORTH YORK CENTRAL - CH   / 37131072326374 
			href = title_field.attributes["href"].value
			title = title_field.text
			# the &nbsp; are getting converted to \u00C2\u00A0 it seems ?  is it right, or buggy iConv  -- https://groups.google.com/forum/?fromgroups#!topic/rubyspreadsheet/EtdRvXDN5rc
			title.tr!("\u00C2\u00A0", " ").strip!
		else
			title = "Uncatalogued"
		end
		local_format = (columns[1] % "em").children.first.to_s
		due_date = parse_due_date_field(columns[3].inner_text.strip)
		c = Checkout.new(title,"",local_format,columns[2].inner_text.to_i,due_date)
		c.href=href if href
		c.unparsed_extra_detail = unparsed_extra_detail
		c
	end
	
	def self.parse_due_date_field(due_date_field)
		raw_due_date,raw_time = due_date_field.split ','
		day, month, year = raw_due_date.split '/'
		due_date = Date.new(year.to_i, month.to_i, day.to_i)
	end
end