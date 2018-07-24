require 'sinatra'
require 'httparty'
require 'securerandom'
require 'twilio-ruby'
require 'optimizely'
require 'faker'

# STEP 1: Add the Optimizely Full Stack Ruby gem
# STEP 2: Require the Optimizely gem 
# STEP 3: Include the twilio account SID, auth token and phone number below

# => Log into Twilio and access the account SID, token, and number
TWILIO_NUMBER = '+33644600560'
TWILIO_ACCOUNT_SID = ''
TWILIO_AUTH_TOKEN = ''

# Optimizely Setup

# Step 4: Replace this url with your own Optimizely Project

DATAFILE_URL = 'https://cdn.optimizely.com/public/8113932881/s/11090871872_11090871872.json'



DATAFILE_URI_ENCODED = URI(DATAFILE_URL)

DATAFILE = HTTParty.get(DATAFILE_URI_ENCODED)


# => Step 5: Use a library, such as HTTParty, to get grab the datafile from the CDN 
#         https://github.com/jnunemaker/httparty#examples
#         example: response = HTTParty.get('http://api.stackexchange.com/2.2/questions?site=stackoverflow').body
#         The above line will return the body of the http request 
#         NOTE: use the uri encoded url shown above :)

DATAFILE_CONTENT = DATAFILE.body

OPTIMIZELY_CLIENT = Optimizely::Project.new(DATAFILE_CONTENT)

# => Step 6: Initialize the Optimizely SDK using the json retrieved from step 4
#		  https://developers.optimizely.com/x/solutions/sdks/reference/?language=ruby

# => Initializing the Twilio client to send sms messages
# => https://www.twilio.com/docs/libraries/ruby
TWILIO_CLIENT = Twilio::REST::Client.new TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN

get '/' do
  puts "[CONSOLE LOG]"
	'Welcome to the SE Full Stack training - S'
end

get '/test' do
  puts "[CONSOLE LOG]"
	'Welcome to the SE Full Stack training - S'
	

	user_id = SecureRandom.uuid

  	puts DATAFILE_CONTENT
  	puts user_id
  	puts OPTIMIZELY_CLIENT

  	puts Faker::ChuckNorris.fact

	# is_new_ui_enabled = optimizely_client.is_feature_enabled(
	#                       'shiny_new_ui', 
	#                       user_id
	#                     )
	# puts is_new_ui_enabled

	# Activate user in an experiment
	variation = OPTIMIZELY_CLIENT.activate("my_experiment", user_id)
	puts variation
	# if variation == 'control'
	  # Execute code for variation A
	# elsif variation == 'treatment'
	  # Execute code for variation B
	# else
	  # Execute default code
	# end

	my_string = "Bla Joke TestBla"
	if my_string.include? "Joke"
	   puts "String includes 'Joke'"
	else
		puts "ELSE"
	end

end

# => GET endpoint to receive messages, this should be setup as a webhook in Twilio
# => anytime twilio receives a message on our number, Twilio will make a request to this endpoint 
get '/sms' do
  
  # => Getting the number that texted the sms service
	sender_number = params[:From]
  
  # => Getting the message that was sent to the service
  # => We could use this to understand what the user said, and create a conversational dialog
	text_body = params[:Body]

  # => Outputing the number and text body to the ruby console
	puts "[CONSOLE LOG] New message from #{sender_number}"
	puts "[CONSOLE LOG] They said #{text_body}"
	puts "[CONSOLE LOG] Let's respond!"

	# =>  Randomly generate a new User ID to demonstrate bucketing
	# =>  Alternatively, you can use sender_number as the user ID, however due to deterministic bucketing using a single user id will always return the same variation
	user_id = SecureRandom.uuid

	# => STEP 7: Implement an Optimizely Full Stack experiment, or feature flag (with variables)
	# => Example, test out different messages in your response
	# => Using the helper function to reply to the number who messaged the sms service
	# => example: send_sms "Hey this is a response!" sender_number

	body = ""

	if text_body.include? "Joke"
		variation = OPTIMIZELY_CLIENT.activate('sms_experiment', user_id)
		# Original Returns a Chuck Norris Fact
		if variation == 'original'
			body += Faker::ChuckNorris.fact
		# Variation returns a IT Crowd Quote
		elsif variation == 'variation'
			body += Faker::TheITCrowd.quote
		else
			body += "Default Answer"
		end
	else
		enabled = OPTIMIZELY_CLIENT.is_feature_enabled('GreekPhilosophers', user_id)
		if enabled
			body += Faker::GreekPhilosophers.quote
		else
			body += "Feature not enabled"
		end
	end

	# Send SMS
	send_sms(body, sender_number)
	# Generate Fake Conversion
	OPTIMIZELY_CLIENT.track("my_conversion", user_id)

end

# => BONUS: Implement a Optimizely webhooks to receive updates when your datafile changes & reinitialize the SDK

# POST Endpoint to update the OPTIMIZELY_CLIENT object by the webhook configured in Optimizely.
# => Every change in Optimizely interface triggers the Webhook and updates the OPTIMIZELY_CLIENT object
# Not super clean as upating a constant variable generates a warning in Ruby. 
# Better solution: create a class with Optimizely client and methods to update and access it.
post '/hook' do
	DATAFILE = HTTParty.get(DATAFILE_URI_ENCODED)
	DATAFILE_CONTENT = DATAFILE.body
	OPTIMIZELY_CLIENT = Optimizely::Project.new(DATAFILE_CONTENT)
end

# =>  Helper function to send a text message
# =>  The first parameter is the content of the text you wish to send
# =>  The second parameter is the number you wish to send the text to
def send_sms body, number
	TWILIO_CLIENT.api.account.messages.create(
      from: TWILIO_NUMBER,
      to: number,
      body: body
    ) 
end




