require 'oauth'
require 'restclient'
require 'open-uri'
require 'yaml'
#require 'nokogiri' didn't have to create the XML request after all, as the access_token seems to do it all for me
#require 'hashie' # Why'd I think I needed this?  Maybe for the Hash.to_xml I hack at the bottom?

class Goodreads
	
	attr_reader :access_token
	
	def initialize
		load_tokens_etc
		access_token_consumer_init
		true
	end
	
	def load_tokens_etc
		# automatically load goodread credentials from the yaml file either in your current directory, or your home
		[ [File.dirname(__FILE__), 'goodreads.yml'], [ENV['HOME'], '.goodreads'] ].each do |path|
			if File.exists?( file = File.join(*path) )
				settings = YAML::load_file(file)
				@developer_key = settings['developer_key']
				@developer_secret = settings['developer_secret']
				@access_token_key = settings['access_token_key']
				@access_token_secret = settings['access_token_secret']
				@user_id = settings['user_id']
			end
		end
		raise Errno::ENOENT, "goodreads yaml config" if @developer_key.nil?
	end
	
	def access_token_consumer_init
		# you can revoke this token from http://goodreads.com/user/edit under the apps tab down at the bottom
		consumer = OAuth::Consumer.new(@developer_key,
                               @developer_secret, 
                               :site => 'http://www.goodreads.com')
		@access_token = OAuth::AccessToken.new(consumer, @access_token_key, @access_token_secret)
	end
	
	def self.book_isbn_to_id(isbn)
		#sleep 1 # API requires me to not hammer their system
		begin
			goodreads_book_id = RestClient.get "http://www.goodreads.com/book/isbn_to_id/#{isbn}?key=#{@developer_key}"
		rescue => e
			puts "   ERROR #{e.message} #{isbn}"
			goodreads_book_id = nil
		end
	end
	
	def shelf_list
		unless @shelf_list
			response = RestClient.get "http://www.goodreads.com/shelf/list.xml?user_id=#{@user_id}&key=#{@developer_key}"
			
			hash = Hash.from_xml(response)[:GoodreadsResponse]
			hash.delete(:Request)
			@shelf_list = hash
		end
		@shelf_list
	end
	
	def shelf_names
		shelves = shelf_list[:shelves][:user_shelf]
		names = []
		shelves.each do |shelf|
			names << shelf[:name]
		end
		names
	end
	
	def shelf_names_by_book(book_id)
		names=[]
		begin # TODO the begin/rescue should probably only trap the 404 for the open but for now it'll do
			response = open "http://www.goodreads.com/review/show_by_user_and_book.xml?user_id=#{@user_id}&book_id=#{book_id}&key=#{@developer_key}"
			hash = Hash.from_xml(response)[:GoodreadsResponse]
			hash.delete(:Request)
			book_review = hash
			
			shelves = book_review[:review][:shelves]
			shelves[:shelf].each do |shelf|
				names << shelf[:attributes][:name]
			end
		rescue
		end
		names
	end
	
	def add_shelf(name)
		#sleep 1 # API requires me not to hammer their system
		response = @access_token.post('/user_shelves.xml', { 
             'user_shelf[name]' => name, 
             'user_shelf[featured]' => false, 
           })
		# TODO check the response code
		@shelf_list = nil
	end
	
	def required_shelves(shelves)
		shelves.each {|shelf| add_shelf(shelf) unless shelf_names.include?(shelf)}
	end
	
	def add_to_shelf(name, book_id)
		sleep 1 # API requires me not to hammer their system
		response = @access_token.post('/shelf/add_to_shelf.xml ', { 
             'name' => name, 
             'book_id' => book_id, 
           })
		# TODO check the response code
	end
	
	def required_shelves_for_library_link
		shelves = %w(checked-out currently-checked-out on-hold)
		shelves << "checked-out-#{Time.now.year}"
		required_shelves(shelves)
	end
	
end


# From: https://gist.github.com/1042973
# I think it's part of Rails core extensions perhaps?  Shoving it here for now cause I can.
# USAGE: Hash.from_xml:(YOUR_XML_STRING)
require 'nokogiri'
# modified from http://stackoverflow.com/questions/1230741/convert-a-nokogiri-document-to-a-ruby-hash/1231297#1231297

class Hash
  class << self
    def from_xml(xml_io)
      begin
        result = Nokogiri::XML(xml_io)
        return { result.root.name.to_sym => xml_node_to_hash(result.root)}
      rescue Exception => e
        # raise your custom exception here
      end
    end

    def xml_node_to_hash(node)
      # If we are at the root of the document, start the hash
      if node.element?
        result_hash = {}
        if node.attributes != {}
          result_hash[:attributes] = {}
          node.attributes.keys.each do |key|
            result_hash[:attributes][node.attributes[key].name.to_sym] = prepare(node.attributes[key].value)
          end
        end
        if node.children.size > 0
          node.children.each do |child|
            result = xml_node_to_hash(child)

            if child.name == "text"
              unless child.next_sibling || child.previous_sibling
                return prepare(result)
              end
            elsif result_hash[child.name.to_sym]
              if result_hash[child.name.to_sym].is_a?(Object::Array)
                result_hash[child.name.to_sym] << prepare(result)
              else
                result_hash[child.name.to_sym] = [result_hash[child.name.to_sym]] << prepare(result)
              end
            else
              result_hash[child.name.to_sym] = prepare(result)
            end
          end

          return result_hash
        else
          return result_hash
        end
      else
        return prepare(node.content.to_s)
      end
    end

    def prepare(data)
      (data.class == String && data.to_i.to_s == data) ? data.to_i : data
    end
  end
  
  def to_struct(struct_name)
      Struct.new(struct_name,*keys).new(*values)
  end
end