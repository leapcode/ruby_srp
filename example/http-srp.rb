require 'sinatra'
require 'pp'
require 'json'

require '../lib/srp'
require 'models/user'
require 'models/log'

get '/' do
  @user = User.current
  erb :index
end

get '/signup' do
  erb :signup
end

# TODO: Client should generate the salt!
# Getting things to work the srp-js way first.
post '/register/salt/' do
  Log.clear
  @user = User.new(params.delete('I'))
  content_type :json
  { :salt => @user.salt.to_s(16) }.to_json
end

post '/register/user' do
  User.current.verifier = params.delete('v').hex
  content_type :json
  { :ok => true }.to_json
end

get '/login' do
  @user = User.current
  erb :login
end

post '/handshake' do
  @user = User.current
  Log.log(:handshake, params)
  @handshake = @user.handshake(params)
  Log.log(:init_auth, @handshake)
  content_type :json
  @handshake.to_json
end

post '/authenticate' do
  @user = User.current
  Log.log(:authenticate, params)
  @auth = @user.validate(params)
  Log.log(:confirm_authentication, @auth)
  content_type :json
  @auth.to_json
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
