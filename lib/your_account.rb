require 'rubygems'
require 'yaml'
require 'nokogiri'
require 'restclient'
require_relative "../lib/checkout.rb"

class YourAccount

	attr_reader :connect_response, :login_response, :page, :library_card, :library_password
	
	def initialize(library_card=nil, library_password=nil)
		unless library_card && library_password
			# automatically load personal account credentials from the yaml file either in your current directory, or your home
			[ [File.dirname(__FILE__), 'tpl.yml'], [ENV['HOME'], '.tpl'] ].each do |path|
				if File.exists?( file = File.join(*path) )
					creds = YAML::load_file(file) and (@library_card, @library_password = creds['library_card'], creds['pin']) and break
				end
			end
			raise Errno::ENOENT, "tpl yaml library_card config" if @library_card.nil?
		else
			@library_card = library_card
			@library_password = library_password
		end
		raise "Library Card # required" if @library_card.nil?
		raise "Library PIN required" if @library_password.nil?
	end
	
	def connect
		@connect_response = RestClient.get "https://www.torontopubliclibrary.ca/youraccount"
	end
	
	def retrieve
	
		connect unless @connect_response
		
		action="https://www.torontopubliclibrary.ca:443/signin?target=youraccount"
		userId = @library_card
		password = @library_password

		# RestClient.post 'http://example.com/resource', :param1 => 'one', :nested => { :param2 => 'two' }
		@login_response = RestClient.post(action, 
		  {:userId => userId, :password => password},
		  {:cookies => @connect_response.cookies}){ |response, request, result, &block|
			if [301, 302, 307].include? response.code
				response.follow_redirection(request, result, &block)
			else
				response.return!(request, result, &block)
			end
		}

		# save a copy of the response so I can play with it locally... consider caching this stuff
		aFile = File.new("tmp/login_response.html", "w")
		aFile.write(@login_response.body)
		aFile.close

		@page = Nokogiri::HTML(@login_response)
	end
	
	def retrieve_stub(filename=nil) # Pull the page from disc while initially parsing
		@page = Nokogiri::HTML(open(filename || "spec/pages/login_response.html"))
	end
	
	def checked_out
		if @checkouts.nil?
			@checkouts=[]
			retrieve unless @page
			(@page/"tbody#renewcharge tr").each do |checkout_row|
				@checkouts << Checkout.parse_from_html(checkout_row)
			end
		end
		@checkouts
	end
	
end