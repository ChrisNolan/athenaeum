Athenaeum -- A Toronto Public Library & Goodreads.com Interface
===============================================================

I've a heavy user of the [Toronto Public Library](http://tpl.ca/) and recently started using [Goodreads.com](http://goodreads.com/), so I decided to join them together.
For now I just automatically take my checked out items and add them to some shelves on goodreads.

Read any [news about the project at my site](http://chrisnolan.ca/tag/athenaeum/).

How to Use
----------

### One time setup/INSTALL

The scripts and program libraries are written in [Ruby (v1.9.3)](http://www.ruby-lang.org/en/downloads/) and use the following gems:
* [nokogiri](http://nokogiri.org/) (1.5.5)
* [oauth](http://rubygems.org/gems/oauth) (0.4.6)
* [rest-client](https://rubygems.org/gems/rest-client) (1.6.7)

From a [command prompt](http://en.wikipedia.org/wiki/Command_line_interface#Command_prompt): "gem install --no-rdoc --no-ri nokogiri oauth rest-client"

You then need a copy of the project on your system.  On the project page, there are the options to: clone, zip or http/ssh/read-only.  If you're going to want to stay updated, then you want to check it out with git.  If you don't have those tools and just want to get started, download the zip.  If you're going to be contributing back to the project, fork/clone it and away you go.

After those are installed, open a command prompt again, change to the project directory and manually:
* Copy the tpl.yml.example file to your home directory and name it .tpl; edit it with your values.  If you manage multiple cards, seperate them with commas (match up the passwords with commas too).
* Run the 'bin/oauth_setup.rb' script from the project directory (i.e. "ruby bin/oauth_setup.rb") and follow the prompts to create your HOME/.goodreads yaml config file.

### Tests

To run the tests, do a 'rake test' from the project directory.  Note: for now many of the tests are set to 'skip' as they aren't mocked against the web.  You can comment out the skip line from each test you want to confirm.

### Regular use

Just do a "ruby bin/tpl-checked-out.rb" from the project directory via a command prompt and it'll pull down your checked out items and push them over to goodreads for you.  
Then goto your "Bookshelves" on Goodreads and you'll see the "checked-out" shelf (another with a bunch of others like 'currently-checked-out' and shelves per subject of the books.

Known Issues
------------
* if a book is on another exclusive shelf it's erroring? (In my case, I 'returned-without-reading' but then checked it out again)

ToDo
----


Thanks
------
* For inspiration: [Sacha Chua](http://sachachua.com/blog/2009/03/new-library-reminder-script/) for her original script, and [Gabriel Mansour](https://github.com/gabrielmansour/tpl-rss/blob/master/tpl-rss.rb) for his TPL RSS script for inspiration.
* [Goodreads API](http://www.goodreads.com/api)
* Dan Sosedoff's [Goodreads Ruby library](https://github.com/sosedoff/goodreads) which is where I'd like some of my api calls to head.
* [Arvid Andersson](http://www.arvidandersson.se/) for his [post on using minitest in Ruby 1.9](http://blog.arvidandersson.se/2012/03/28/minimalicous-testing-in-ruby-1-9).