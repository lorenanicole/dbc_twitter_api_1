require 'pry'

get '/' do

  # p $client.update(params[:new_tweet])
  $client.update("I'm tweeting with @gem from Johore, Malayasia!!", :lat => 1.3000, :long => 103.8000, :display_coordinates => true)
  erb :index
end

get '/temp' do
  puts "LOG #{params[:username]}"
  @user = TwitterUser.find_by_username(params[:username])
  if @user == nil
    @user = TwitterUser.create(username: params[:username])
    @user.fetch_tweets!
    redirect "/#{params[:username]}"
  end
  @user.tweets_stale?
  redirect "/#{params[:username]}"
end

get '/:username' do
  @user = TwitterUser.find_by_username(params[:username])
  @tweets = @user.tweets.limit(10).all
  puts "#{@tweets}"
  erb :user_page
end
