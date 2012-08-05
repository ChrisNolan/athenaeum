require 'open-uri'
require 'nokogiri'


class LibraryDetail

	attr_reader :library_id, :page, :isbn, :isbns
	
	def initialize(library_id, page)
		@library_id = library_id
		@page = page
		parse_page
	end
	
	def parse_page
		# TODO get the title from the h1.align-top minus the span.title_edition_results
		isbn_rows = @page.css('tr.isbn')
		@isbns = []
		if isbn_rows.size > 1
			isbn_rows.each do |isbn_row|
				isbn = isbn_row.css('td').text
				@isbns << isbn
				@isbn = isbn if is_number?(isbn)  # my cheat to find one ISBN out of the list of isbn to use is to pick the one that doesn't have any text along with the isbn
			end
			unless @isbn # extra catch if ISBN wasn't set in the above loop, set it to just the integers of the last listed isbn
				@isbn = @isbns.last.to_i.to_s
				@isbn = @isbns.last[0,10] if @isbn.length < 10
			end
		else
			isbn_text = isbn_rows.css('td').text
			@isbn = isbn_text.to_i.to_s
			@isbn = isbn_text[0,10] if @isbn.length < 10
			@isbns << @isbn
		end
	end
	
	def self.retrieve(library_id_to_retrieve)
		# TODO set my user-agent somehow
		response = open("http://www.torontopubliclibrary.ca/detail.jsp?R=#{library_id_to_retrieve}")
		
		# save a copy of the response so I can play with it locally... consider caching this stuff
		aFile = File.new("library_detail_#{library_id_to_retrieve}.html", "w")
		aFile.write(response.read)
		aFile.close
		
		#page = Nokogiri::HTML(open("http://www.torontopubliclibrary.ca/detail.jsp?R=#{library_id_to_retrieve}"))
		page = Nokogiri::HTML(open(aFile))
		new(library_id_to_retrieve, page)
	end
	
	def self.retrieve_stub(library_id_to_retrieve)
		filename = "library_detail_#{library_id_to_retrieve}.html"
		if File.exists? filename
			page = Nokogiri::HTML(open(filename))
			new(library_id_to_retrieve, page)
		else
			retrieve(library_id_to_retrieve)
		end
	end
	
	private
	
	def is_number?(i)
		true if Float(i) rescue false
	end
	
end