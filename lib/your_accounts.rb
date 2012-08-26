require 'rubygems'
require 'yaml'
require_relative "../lib/your_account.rb"

class YourAccounts

	attr_reader :library_cards, :library_passwords, :accounts

	def initialize(library_cards=nil, library_passwords=nil)
		unless library_cards && library_passwords
			# automatically load personal account credentials from the yaml file either in your current directory, or your home
			[ [File.dirname(__FILE__), 'tpl.yml'], [ENV['HOME'], '.tpl'] ].each do |path|
				if File.exists?( file = File.join(*path) )
					creds = YAML::load_file(file) and (library_cards, library_passwords = creds['library_card'], creds['pin']) and break
				end
			end
			raise Errno::ENOENT, "tpl yaml library_card config" if library_cards.nil?
		else
		end
		@library_cards = library_cards.to_s.split(',').map(&:strip)
		@library_passwords = library_passwords.to_s.split(',').map(&:strip)
		raise "Library Card # required" if @library_cards.nil?
		raise "Library PIN required" if @library_passwords.nil?
		init_accounts
	end
	
	def init_accounts
		@accounts = []
		@library_cards.each_with_index do |library_card, card_index|
			@accounts << YourAccount.new(library_card, @library_passwords[card_index])
		end
	end

	def checked_out
		total_checked_out = []
		@accounts.each do |your_account|
			total_checked_out += your_account.checked_out
		end
		total_checked_out
	end
	
end