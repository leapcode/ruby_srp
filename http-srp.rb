require 'sinatra'
require 'pp'

class User

  def self.current
    # p "getting #{@current ? @current.login : 'nil'}"
    @current ||= User.new
  end

  attr_accessor :login
  attr_accessor :password
  attr_accessor :active

  def signup!(params)
    self.login = params.delete('login')
    p "signing up as #{login}"
    self.password = params.delete('password')
    self.active = false
  end

  def login!(params)
    self.active = valid_login?(params[:login], params[:password])
  end

  def valid_login?(login, password)
    (self.login == login) and (self.password == password)
  end
end

get '/' do
  @user = User.current
  p "visiting / as #{@user.login}"
  erb :index
end

get '/signup' do
  erb :signup
end

post '/signup' do
  @user = User.current
  @user.signup!(params)
  redirect '/'
end

get '/login' do
  erb :login
end

post '/login' do
  @user = User.current
  @user.login!(params)
  redirect '/'
end
