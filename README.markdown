Athenaeum -- A Toronto Public Library & Goodreads.com Interface
===============================================================

How to Use
----------

The scripts and program libraries are written in Ruby (v1.9.3) and use the following gems:
* nokogiri (1.5.5)
* oauth (0.4.6)
* rest-client (1.6.7)

Copy the tpl.yml.example file to your home directory and name it .tpl; edit it with your values
Copy the goodreads.yml.example file to your home directory and name it .goodreads; edit it with your values (TODO document how to get the values for this file)

To run the tests, do a 'rake test' from the project directory.  Note: for now many of the tests are set to 'skip' as they aren't mocked against the web.

Known Issues
------------


ToDo
----


Thanks
------
Thanks to [Sacha Chua](http://sachachua.com/blog/2009/03/new-library-reminder-script/) for her original script, and [Gabriel Mansour](https://github.com/gabrielmansour/tpl-rss/blob/master/tpl-rss.rb) for his TPL RSS script for inspiration.