### add_retweet
### Parameters: status- The retweet information 
### Returns: Sets the application-scope variable @tweet_db. If the original tweet has already been retweeted, it will just add the newest retweet's information under @tweet_db[<original id>][:retweets][<new retweet id>]. 
def add_retweet(status)
	@tweet_db[status.retweeted_status.id] ||= {
		:original => status.retweeted_status,
		:retweets => {}
	}
	@tweet_db[status.retweeted_status.id][:retweets][status.id] = status
end

### filter_old_retweets
### Parameters: none
### Returns: Deletes old retweets if they were created longer than the user defined window
def filter_old_retweets
	@tweet_db.each do |tweet_id, tweet_data|
		tweet_data[:retweets].delete_if do |id, retweet| 
			#if the time now in minutes is greater than or equal to the user defined
			#window, then remove that retweet.
			(Time.now - retweet.created_at).to_i / 60 >= @user_defined_window
		end
	end
end

### check_if_top_changed
### Parameters: none
### Returns: Sets variable @top_after_new_stream with the sorted tweets by # of retweets
def check_if_top_changed
	@top_after_new_stream = @tweet_db.sort_by {|tweet_id, tweet_data| tweet_data[:retweets].length}.reverse.shift(10)
	@top_after_new_stream.map! do |element|
		[element[0], element[1][:retweets].length]
	end
end

### display_new_retweets
### Parameters: none
### Returns: Outputs to console top 10 retweets
def display_new_retweets
	@curr_top = @top_after_new_stream
	clear_screen
	puts ""
	puts "*"*50
	puts "TOP RETWEETS IN LAST #{@user_defined_window} MINUTE(S)"
	puts "*"*50
	puts ""
	@curr_top.each do |retweet|
		text = @tweet_db[retweet[0]][:original].text.gsub(/\n/," ")
		count = retweet[1]
		puts  "Retweet Count: #{count} Text: #{text}"
	end
end

def clear_screen
	print "\e[2J\e[f"
end