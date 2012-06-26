require 'sinatra'
require 'pp'

require 'models/user'
require 'models/log'

get '/' do
  @user = User.current
  erb :index
end

get '/signup' do
  erb :signup
end

post '/signup' do
  Log.clear
  Log.log(:signup, params)
  @user = User.current
  @user.signup!(params)
  redirect '/'
end

get '/login' do
  erb :login
end

post '/login' do
  Log.log(:login, params)
  @user = User.current
  if @user.login!(params)
    Log.log(:response, "Login succeeded")
  else
    Log.log(:response, "Login failed")
  end
  redirect '/'
end

get '/verify' do
  erb :verify
end

helpers do
  def button_link(action, options = {})
    action = action.to_s
    label = action.capitalize
    klass = "btn btn-large"
    if options.delete(:primary)
      klass += " btn-primary"
      label += " now..."
    end
    %Q(<a href="#{action}" class="#{klass}" id="#{action}-btn">#{label}</a>)
  end
end
