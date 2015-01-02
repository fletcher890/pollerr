module Pollerr

  class Poll

    include DataMapper::Resource
    belongs_to :user
    has n,     :reply
    has n,     :question

    property :id,                 Serial
    property :user_id,            Integer
    property :title,              String
    property :status,             String, :default => "draft"
    property :password_protected, String, :default => "N"
    property :password,           String
    property :created_at,         DateTime
    property :created_on,         Date
    property :updated_at,         DateTime
    property :updated_on,         Date

  end

  class User

    include DataMapper::Resource
    has n,     :poll
    has 1,     :setting

    ## Database authenticatable
    property :id,                 Serial
    property :username,           String
    property :admin,              String, :default => "N"
    property :email,              String, :default => ""
    property :encrypted_password, String, :default => ""
    property :created_at,         DateTime
    property :created_on,         Date
    property :updated_at,         DateTime
    property :updated_on,         Date

    accepts_nested_attributes_for :setting

  end

  class Question

    include DataMapper::Resource
    belongs_to :poll
    has n,     :possible_answer

    property :id,                 Serial
    property :title,              String
    property :kind,               String, :default => "open"
    property :required,           String, :default => "Y"
    property :poll_id,            Integer
    property :created_at,         DateTime
    property :created_on,         Date
    property :updated_at,         DateTime
    property :updated_on,         Date

    accepts_nested_attributes_for :possible_answer

  end

  class PossibleAnswer 

    include DataMapper::Resource
    belongs_to :question

    property :id,                 Serial
    property :title,              String
    property :question_id,        Integer
    property :created_at,         DateTime
    property :created_on,         Date
    property :updated_at,         DateTime
    property :updated_on,         Date

  end

  class Reply

    include DataMapper::Resource
    belongs_to :poll
    has n,     :answer

    property :id,                 Serial
    property :poll_id,            Integer
    property :created_at,         DateTime
    property :created_on,         Date
    property :updated_at,         DateTime
    property :updated_on,         Date

    accepts_nested_attributes_for :answer

  end

  class Answer

    include DataMapper::Resource

    belongs_to :reply
    belongs_to :question

    property :id,                 Serial
    property :reply_id,           Integer
    property :question_id,        Integer
    property :value,              String
    property :created_at,         DateTime
    property :created_on,         Date
    property :updated_at,         DateTime
    property :updated_on,         Date

  end

  class Setting

    include DataMapper::Resource

    belongs_to :user

    property :id,                   Serial
    property :user_id,              Integer
    property :logo,                 String
    property :complete_message,     Text
    property :company_name,         String
    property :required_by_default,  String, :default => "Y"
  end

  require 'sinatra'
  require 'rack-flash'
  require 'digest/sha1'
  require 'haml'

  class App < Sinatra::Base

    configure :development do
 
      enable :sessions, :logging, :dump_errors, :inline_templates
      disable :method_override
      disable :static

      set :root, File.dirname(__FILE__)
      logger = Logger.new($stdout)

      use Rack::Deflater


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
      if !logged_in? && request.path_info != '/login' && request.path_info != '/register' && !request.path_info.include?('/take-survey') && !request.path_info.include?('/api')
        redirect('/login') and return 
      end
    end

    get '/' do
      haml :index
    end

    # Start of polls REST

    get '/api/polls' do 
      content_type :json
      Poll.all(:user_id => session[:user_id]).to_json
    end

    post "/api/polls"  do 
      ng_params = JSON.parse(request.body.read)
      poll = Poll.first(ng_params)
      if poll.nil?
        poll = Poll.create(ng_params)
        poll[:user_id] = session[:user_id].to_i
        poll.save()
        content_type :json
        return poll.to_json
      end

    end

    put '/api/polls/:id' do 
      poll = Poll.get(params[:id].to_i)
      poll.attributes = JSON.parse(request.body.read)
      poll.save()
      content_type :json
      return poll.to_json
    end

    get "/api/polls/:id" do 
      poll = Poll.get(params[:id].to_i)
      content_type :json
      return poll.to_json(relationships: { reply: { methods: [ :desc ] }, question: { methods: [ :desc ] } })
    end

    get "/api/live-polls/:id" do 
      poll = Poll.first(:id => params[:id].to_i, :status => 'live')
      content_type :json
      return poll.to_json
    end

    delete '/api/polls/:id' do 
      Poll.get(params[:id].to_i).destroy
      return {}.to_json
    end

    get '/api/poll-json/:id' do 
      poll = Poll.get(params[:id].to_i)
      return PollSerializer.count_per_month(poll).to_json
    end

    # End of polls

    # Start of Questions REST

    get "/api/questions" do 
      content_type :json
      return Question.all.to_json
    end

    post "/api/questions" do 
      ng_params = JSON.parse(request.body.read)
      question = Question.create(ng_params)
      question.save()
      content_type :json
      return question.to_json
    end

    get "/api/questions/:id" do 
      question = Question.get(params[:id].to_i)
      content_type :json
      return question.to_json(relationships: { possible_answer: { methods: [ :title ] } })
    end

    get "/api/questions_by_poll/:id" do 
      content_type :json
      return Question.all(:poll_id => params[:id].to_i).to_json(relationships: { possible_answer: { methods: [ :title ] } })
    end

    put '/api/questions/:id' do 
      question = Question.get(params[:id].to_i)
      PossibleAnswer.all(:question_id => params[:id].to_i).destroy
      question.attributes = JSON.parse(request.body.read)
      question.save()
      content_type :json
      return question.to_json
    end

    delete "/api/questions/:id" do 
      Question.get(params[:id].to_i).destroy
      return {}.to_json
    end

    # End of questions REST

    post "/api/reply" do 
      ng_params = JSON.parse(request.body.read)
      reply = Reply.create(ng_params)
      reply.save()
      content_type :json
      return reply.to_json
    end

    get "/api/reply/:id" do 
      reply = Reply.get(params[:id].to_i)
      content_type :json
      return reply.to_json(relationships: { answer: { methods: [ :id ], relationships: { question: { methods: [:id] } } } })
    end

    get "/api/user" do 
      user = User.first(:id => session[:user_id].to_i)
      content_type :json
      return user.to_json(relationships: { setting: { methods: [:id] } } )
    end

    put "/api/user/:id" do 
      user = User.get(params[:id].to_i)
     
      ng_params = JSON.parse(request.body.read)
      if ng_params.has_key?('password')
        ng_params['encrypted_password'] = Digest::SHA1.hexdigest(ng_params['password'])
        ng_params.delete('password')
      end

      Setting.all(:user_id => session[:user_id].to_i).destroy
      user.attributes = ng_params
      user.save()

      content_type :json
      return user.to_json
    end

    get '/api/settings-by-user/:id' do 
      setting = Setting.first(:user_id => params[:id].to_i)
      content_type :json
      return setting.to_json
    end

    get '/api/login' do 
      haml :login, :layout => :authentication
    end

    post '/api/login' do 
      user = User.first(:username => params[:username], :encrypted_password => Digest::SHA1.hexdigest(params[:password]))
      if user.nil?
        flash[:error] = 'Invalid log in credentails'
        redirect('/login')
      else
        flash[:notice] = "Successfully logged in"
        session[:email] = user.email
        session[:user_id] = user.id
        redirect('/')
      end

    end

    post '/api/register' do 

      if !User.first(:email => params[:user][:email]).nil?
        flash[:error] = "Somebody is already registered with this email address"
        redirect('/login');
      else
        t = User.create(params[:user])
        t.encrypted_password = Digest::SHA1.hexdigest(params[:password])
        t.save()

        settings = Setting.create(:user_id => t.id).save()

        session[:email] = t.email
        session[:user_id] = t.id
        flash[:notice] = "You have been successfully registered and logged in"
        redirect('/')
      end

    end

    get '/api/logout' do 
      session[:email] = nil
      flash[:notice] = "Successfully logged out. Don't be a stranger, come back again soon!"
      redirect('/login')
    end

    get '/*' do
      haml :index
    end

  end

end