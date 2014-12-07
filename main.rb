module CORE

  class Poll
    include Mongoid::Document
    field :title, type: String
  end

  class User
    include Mongoid::Document
    ## Database authenticatable
    field :username,           type: String
    field :admin,              type: String, default: "N"
    field :email,              type: String, default: ""
    field :encrypted_password, type: String, default: ""
  end

  require 'sinatra'
  require 'rack-flash'
  require 'mongoid'
  require "digest/sha1"
  require 'haml'

  class Main < Sinatra::Base

    configure :development do
 
      enable :sessions, :logging, :dump_errors, :inline_templates
      enable :methodoverride
      set :root, File.dirname(__FILE__)
      logger = Logger.new($stdout)


    end

    configure do 
      enable :sessions
      set :session_secret, 'gdjfiojvshfuodisjfioufj8qejvwuicsajoio576890'
      use Rack::Flash
    end

    module UserSession
      
      def logged_in?
       not session[:email].nil?
      end
      
      def logout!
        session[:email] = nil
      end

      def get_notifications
      
        html = ''

        if flash[:error]
          html += "<div class='alert alert-danger'><button type='button' class='close' data-dismiss='alert'>x</button><strong>Error!</strong> #{flash[:error]}</div>"
        end

        if flash[:notice]
          html += "<div class='alert alert-success'><button type='button' class='close' data-dismiss='alert'>x</button><strong>Success!</strong> #{flash[:notice]}</div>"
        end

        html.html_safe 
      end

    end

    helpers UserSession
 
    before do
      if !logged_in? && request.path_info != '/login' && request.path_info != '/register'
        redirect('/login') and return 
      end
    end

    get '/' do
      haml :index
    end

    get '/api/polls' do 
      content_type :json
      Poll.all.entries.to_json
    end

    get '/api/polls/new' do 
      abort 'new poll'.inspect
    end

    post "/api/polls"  do 
      ng_params = JSON.parse(request.body.read).symbolize_keys
      poll = Poll.where({ title: ng_params[:title][0] }).first
      if poll.blank?

        poll = Poll.new
        poll.title = ng_params[:title][0]
        poll.save

        content_type :json
        return poll.to_json
      end
    end

    get '/api/polls/:id' do 
      ng_params = JSON.parse(request.body.read).symbolize_keys
      poll = Poll.where({ title: 'testing' }).first
      abort poll.inspect
    end

    put '/api/polls/:id' do 
      abort 'update the poll'.inspect
    end

    delete '/api/polls/:id' do 
      abort 'delete the poll'.inspect
    end

    get '/login' do 
      haml :login, :layout => :authentication
    end

    post '/login' do 
      user = User.where(username: params[:username], encrypted_password: Digest::SHA1.hexdigest(params[:password])).first
      if user.blank?
        flash[:error] = 'Invalid log in credentails'
        redirect('/login')
      else
        flash[:notice] = "Successfully logged in"
        session[:email] = user.email
        redirect('/')
      end
    end

    post '/register' do 

      if !User.where(email: params[:user][:email]).first.blank?
        flash[:error] = "Somebody is already registered with this email address"
        redirect('/login');
      else
        t = User.new(params[:user])
        t.encrypted_password = Digest::SHA1.hexdigest(params[:password])
        t.save()
        session[:email] = t.email
        flash[:notice] = "You have been successfully registered and logged in"
        redirect('/')
      end

    end

    get '/logout' do 
      session[:email] = nil
      flash[:notice] = "Successfully logged out. Don't be a stranger, come back again soon!"
      redirect('/login')
    end

    get '/*' do
      haml :index
    end

  end

end