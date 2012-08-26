load"lib/your_accounts.rb"
load"lib/library_detail.rb"
load"lib/goodreads.rb"

goodreads = Goodreads.new
goodreads.required_shelves_for_library_link

your_accounts=YourAccounts.new # card info coming from home/.tpl
your_accounts.checked_out.each do |checkout|
	next unless checkout.local_format == "Book" # skip DVDs and CDs and magazines etc
	library_detail = LibraryDetail.retrieve_stub(checkout.library_id) # _stub for testing
	goodreads_book_id = goodreads.book_isbn_to_id library_detail.isbn
	if goodreads_book_id
		shelves = library_detail.subjects
		puts "* #{checkout.title}\t#{library_detail.isbn}\t#{goodreads_book_id}"
		shelf_names_by_book = goodreads.shelf_names_by_book(goodreads_book_id)
		shelves << 'to-read' if shelf_names_by_book.empty? # in theory if it's just checked out I haven't read it yet, and the default goodreads action when I add a never seen book before to another shelf is to also add it to the 'read' shelf.  
		shelves << 'checked-out'
		shelves << "checked-out-#{Time.now.year}"
		#goodreads.add_to_shelf "checked-out-#{Time.now.year}-#{Time.now.month}", goodreads_book_id # track what was checked out each month... but first add check to walk back 3 weeks from the renew date so it doesn't fill multiple months un-necessarily
		goodreads.add_to_shelf shelves, goodreads_book_id
	else
		puts " *** Unable to get BookID for #{checkout.title}"
	end
end
