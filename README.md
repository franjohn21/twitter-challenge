*** Twitter challenge ***

Built on Sinatra/Ruby. It's a backend application so it communicated with Twitter's API on the server and spits out output to the terminal. 

To run -- download repo and bundle install. Modify user_defined_window in app/controllers/index.rb. 
This will require adding in a .env file underneath the main directory and populating:
CONSUMER_KEY
CONSUMER_SECRET
OAUTH_KEY
OAUTH_SECRET


Then run 'shotgun' in terminal. Browse to http://localhost:9393 and that will jumpstart the app in terminal. 

