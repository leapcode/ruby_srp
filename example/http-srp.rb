require 'sinatra'
require 'pp'

require 'models/user'
require 'models/log'
require '../lib/srp'

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
  @user = User.current
  erb :login
end

post '/handshake/' do
  @user = User.current
  Log.log(:handshake, params)
  @auth = @user.initialize_auth(params)
  Log.log(:init_auth, @auth)
  erb :handshake, :layout => false, :content_type => :xml
end

post '/authenticate/' do
  @user = User.current
  Log.log(:authenticate, params)
  @auth = @user.authenticate(params)
  Log.log(:confirm_authentication, @auth)
  erb :authenticate, :layout => false, :content_type => :xml
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
    %Q(<a href="#{action}" class="#{klass}" id="#{action}-view-btn">#{label}</a>)
  end
end
