# SE Full Stack Sample Implementation Twilio App
--- and open the prothis guide you will be tasked with implementing the Optimizely Ruby SDK, and using a Full Stac"

The sample application here is all setup so that all you need to do is reserve a phone number in Twilio, enter your credentials, and implement Optimizely.

Instructions are given6. Open the 
 as comments in the ```server.rb``` file, but repeated here with additional context and initial setup steps.

When followed closely, this project should take no more than 1-2 hours.

Need some help? Like any good developer, when in doubt, Google it out. If that doesn't help, here are a few resources that might help. If none of these help, contact Andreas :)

- [Optimizely Developer Docs](https://developers.optimizely.com)
- [Stack Overflow](https://stackoverflow.com)
- [Sinatra gem](http://sinatrarb.com/)
- [ngrok](https://www.npmjs.com/package/ngrok)

**Happy coding!**

## Technologies used
---
Language = Ruby
ngrok (tunnels a local server to a public facing endpoint)
Libraries
- Sinatra (framework for creating endpoints)
- Twilio (for sending SMS messages)
- HTTParty (for making HTTP requests)
- securerandom (generates a random UUID)

## Initial setup
---
1. Install ngrok using terminal - I prefer doing this via npm, but there are alternative ways to install ngrok
```sudo npm install -g ngrok```
If the above command fails, try ``` sudo npm i -g ngrok --unsafe-perm=true --allow-root```

2. Fork this repository, and clone it
```click fork``` > ```click clone``` > ```copy the key to clone the repo``` in your terminal run ```git clone [the text you just copied]```

3. Log into Twilio"
4. In the Twilio console, click the "#" in the lefthand nav, then click "+"
5. Search for and buy a phone number, this will be the number for your sms bot (important! make sure that the number you buy is compatible with SMS)
6. Open ```server.rb``` in your prefered text editor
7. In ```server.rb``` replace the TWILIO_NUMBER value with the number you purchased in step 5
8. In the Twilio console, click to view the dashboard and note the Account SID and Auth Token
9. Replace the ```TWILIO_ACCOUNT_SID``` and ```TWILIO_AUTH_TOKEN``` with the SID and token found in step 8.
10. Create an Optimizely Full Stack project and replace the ```DATAFILE_URL``` in ```server.rb```, with your own projects datafile

## Let's get started!
---

Now that we've done the initial setup we can start implementing the SDK and coding our experiment!

Here are the steps you'll need to follow to get started:
For help with implementing Optimizely, use the [developer docs](https://developers.optimizely.com/x/solutions/sdks/reference/?language=ruby)

1. Add the Optimizely Ruby gem to your Gemfile
2. In the directory of your application, run ```bundle install``` in the terminal
3. Require the Optimizely SDK in ```server.rb```
4. Use HTTParty to access the json of the datafile
5. Initialize the Optimizely SDK
6. Create an experiment in Optimizely, and implement it within the ```get /sms``` function

### when you're ready to test your application

1. In your terminal, run ```ruby server.rb``` (verify your server is running by going to http:localhost:4567)
2. In a separate terminal window (while the ruby server is running in the other), run ```ngrok http 4567``` 
- This will create a public url to access your local server
3. In the terminal window where you ran ```ngrok http 4567``` copy the https url shown
4. Paste the url in a browser tab and verify you're able to access the same page as in step 1
5. Return to www.twilio.com and click the "#" tab on the left
6. Locate the number you purchased in step 5 and click to manage the number
7. Scroll down and find the messaging section
8. In the "A message comes in" section, select "Webhook" from the drop down and paste the URL copied in step 3 above and past it in the webhook form field with "/sms" included as a path at the end of the URL.
9. In the drop down menu next to the form field, select "HTTP GET" and click save

When your application is working, follow the steps below to create a branch and push your changes to that branch

1. In your app directory from the terminal enter ```git add .```
2. ```git checkout -b [your branch name]``` NOTE: branch names may not contain any spaces ex "andreas/my_branch-name" is a valid name
2. ```git commit -m [give your commit a name]``` commit messages may contain spaces
3. ```git push origin [the branch name you created in step 2]```

This will push all of your changes to the master branch of your forked repository.

That's it! By now you should have:
1. Forked this repository
2. Setup your application and implemented Full Stack
3. Made your application public via ngrok
4. Connected your application to Twilio
5. Pushed your code back to Github

To submit your exercise email a link with Github repo to Zach, Joe or Andreas.




