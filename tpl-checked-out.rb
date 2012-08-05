load"lib/your_account.rb"
load"lib/library_detail.rb"
load"lib/goodreads.rb"

goodreads = Goodreads.new
goodreads.required_shelves_for_library_link

your_account=YourAccount.new # card info coming from home/.tpl
your_account.retrieve#_stub # _stub of course is just during testing
total_checked_out = your_account.checked_out
# If you don't manage multiple cards comment out the new few lines, otherwise fill in the values
your_account=nil
your_account=YourAccount.new("2nd library card", "2nd library card password") # get 2nd card # could I put both in the yaml file instead?
your_account.retrieve
total_checked_out += your_account.checked_out
total_checked_out.each do |checkout|
	next unless checkout.local_format == "Book" # skip DVDs and CDs and magazines etc
	library_detail = LibraryDetail.retrieve_stub(checkout.library_id) # _stub for testing
	goodreads_book_id = Goodreads.book_isbn_to_id library_detail.isbn
	if goodreads_book_id
		puts "* #{checkout.title} \t#{library_detail.isbn} \t#{goodreads_book_id}"
		# TODO consider an add_to_shelves where you give the list of shelves to add the book too
		shelf_names_by_book = goodreads.shelf_names_by_book(goodreads_book_id)
		goodreads.add_to_shelf 'to-read', goodreads_book_id if shelf_names_by_book.empty? # in theory if it's just checked out I haven't read it yet, and the default goodreads action when I add a never seen book before to another shelf is to also add it to the 'read' shelf.  
		goodreads.add_to_shelf 'checked-out', goodreads_book_id
		goodreads.add_to_shelf "checked-out-#{Time.now.year}", goodreads_book_id
		#goodreads.add_to_shelf "checked-out-#{Time.now.year}-#{Time.now.month}", goodreads_book_id # track what was checked out each month... but first add check to walk back 3 weeks from the renew date so it doesn't fill multiple months un-necessarily
	else
		puts " *** Unable to get BookID for #{checkout.title}"
	end
end
