#
# Quick script to just list all your checked out items
#
load"lib/your_accounts.rb"

your_accounts=YourAccounts.new # card info coming from home/.tpl
your_accounts.checked_out.each do |checkout|
	next unless checkout.local_format == "Book" # skip DVDs and CDs and magazines etc
	puts "* #{checkout.title}\t"
end
