module CORE

  class Poll
    include DataMapper::Resource
    property :id,     Serial
    property :title,  String
  end

  class User
    include DataMapper::Resource
    ## Database authenticatable
    property :id,                 Serial
    property :username,           String
    property :admin,              String, :default => "N"
    property :email,              String, :default => ""
    property :encrypted_password, String, :default => ""
  end

  require 'sinatra'
  require 'rack-flash'
  require 'digest/sha1'
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

        return (html.respond_to?(:html_safe) && html.html_safe) || html
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
      Poll.all.to_json
    end

    get '/api/polls/new' do 
      abort 'new poll'.inspect
    end

    post "/api/polls"  do 
      ng_params = JSON.parse(request.body.read)
      poll = Poll.first(ng_params)
      if poll.nil?
        poll = Poll.create(ng_params)
        poll.save()
        content_type :json
        return poll.to_json
      end
    end

    delete '/api/polls/:id' do 
      abort 'delete the poll'.inspect
    end

    get '/login' do 
      haml :login, :layout => :authentication
    end

    post '/login' do 
      user = User.first(:username => params[:username], :encrypted_password => Digest::SHA1.hexdigest(params[:password]))
      if user.nil?
        flash[:error] = 'Invalid log in credentails'
        redirect('/login')
      else
        flash[:notice] = "Successfully logged in"
        session[:email] = user.email
        redirect('/')
      end
    end

    post '/register' do 

      if !User.first(:email => params[:user][:email]).nil?
        flash[:error] = "Somebody is already registered with this email address"
        redirect('/login');
      else
        t = User.create(params[:user])
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