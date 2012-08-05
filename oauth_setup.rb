# from http://www.goodreads.com/api/oauth_example & http://www.goodreads.com/topic/show/418304-really-simple-ruby-oauth-example
require 'rubygems'
require 'oauth'

developer_key=""
developer_secret=""
x=""

# pass in your developer key and secret
puts ""
puts "Visit http://www.goodreads.com/api/keys and get yourself a dev key.  Just put anything in the fields, doesn't matter"
puts "Copy & Paste developer key"
developer_key = gets
developer_key.chomp!
puts "Copy & Paste developer secret"
developer_secret = gets
developer_secret.chomp!
puts ""
consumer = OAuth::Consumer.new(developer_key, 
                               developer_secret, 
                               :site => 'http://www.goodreads.com')
request_token = consumer.get_request_token
puts ""
puts "Visit"
puts "\t#{request_token.authorize_url}"
puts "and then return here and press anykey"
x = gets
access_token = request_token.get_access_token

# in the initial session, we'll store token and secret somewhere
access_token_key = access_token.token
access_token_secret = access_token.secret

# in subsequent sessions, we'll rebuild the access token

# how does one revoke the token? -- see http://www.goodreads.com/topic/show/773652-how-to-revoke-oauth-authorization?page=1#comment_48423568
consumer = OAuth::Consumer.new(developer_key,
                               developer_secret, 
                               :site => 'http://www.goodreads.com')
access_token = OAuth::AccessToken.new(consumer, access_token_key, access_token_secret)

puts "Copy & Paste the following into your #{ENV['HOME']}/.goodreads config file"
puts ""
puts "developer_key:\t#{developer_key}"
puts "developer_secret:\t#{developer_secret}"
puts "access_token_key:\t#{access_token_key}"
puts "access_token_secret:\t#{access_token_secret}"
puts "user_id:\tEDIT THIS MANUALLY. Click your user photo on goodreads and copy the number after /user/show/ and without the -name."
puts ""