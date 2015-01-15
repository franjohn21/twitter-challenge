get '/' do 
	@tweet_db = {}
	@curr_top, @top_after_new_stream = [], []
	#size in minutes of window to display tweets
	@user_defined_window = 1

	client = TweetStream::Client.new

	client.on_error do |message|
		client.stop
		puts "*"*50
		puts message
		puts "-"*50
	end

	client.sample do |status|
		add_retweet(status) if status.retweet?
		filter_old_retweets
		check_if_top_changed
		display_new_retweets if @curr_top != @top_after_new_stream
	end
end
