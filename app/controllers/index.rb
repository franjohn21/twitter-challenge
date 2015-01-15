get '/' do 
	tweet_info_hash = {}
	retweets_hash = {}
	top_retweets = []

	#size in minutes of window to display tweets
	user_defined_window = 3

	client = TweetStream::Client.new

	client.on_error do |message|
		client.stop
		puts "*"*50
		puts message
		puts "*"*50
	end

	begin
		client.sample do |status, client|
			#if it's a retweet, keep count
			if status.retweet?
				if retweets_hash[status.retweeted_status.id] == nil
					retweets_hash[status.retweeted_status.id] = 1
					tweet_info_hash[status.retweeted_status.id] = status
				else
					retweets_hash[status.retweeted_status.id] += 1
				end
			end

			#filter 'old' tweets
			to_delete = tweet_info_hash.select {|id, tweet| (Time.now - tweet.created_at).to_i / 60 >= user_defined_window}

			to_delete.keys.each do |tweet_id|
				tweet_info_hash.delete(tweet_id)
				retweets_hash.delete(tweet_id)
			end
			#compare the top retweeted to previous top
			top_after_sampling = retweets_hash.values.sort.reverse.shift(10)

			#display new retweets if there is a difference
			if top_retweets != top_after_sampling
				top_retweets = top_after_sampling
				display_retweets = retweets_hash.sort_by {|key, vals| vals}.reverse.shift(10)
				clear_screen
				puts ""
				puts "*"*50 
				puts "TOP RETWEETS IN LAST #{user_defined_window} MINUTES "
				puts "*"*50
				puts ""
				display_retweets.each do |retweet|
					text = tweet_info_hash[retweet[0]].text.gsub(/\n/," ")
					puts  "Retweet Count: #{retweet[1]} Text: #{text}"
					# p (Time.now - tweet_info_hash[retweet[0]].created_at).to_i / 60
				end
			end
		end
	rescue StandardError => e
		puts e
	end
end


def clear_screen
	print "\e[2J\e[f"
end