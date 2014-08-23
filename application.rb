require 'bundler/setup'
Bundler.require :default
require 'sinatra/base'
#require 'rack-flash'

%w(lib models).each do |l|
  Dir[File.expand_path("./#{l}/*.rb")].each {|f| require f }
end

class Website < Sinatra::Base
  root_dir = File.dirname(__FILE__)

  register Sinatra::ActiveRecordExtension
  register Sinatra::Bootstrap::Assets
  register Sinatra::SimpleAuthentication
 
  #use Rack::Flash, :sweep => true
  use FlyerAjax::Controller

  set :environment, ENV['RACK_ENV'] || :development
  set :root, root_dir
  set :app_file, __FILE__
  set :static, true

  configure :development do
    enable :logging
  end

  helpers do      
    include Helpers
  end

  before do
    #login_required unless %w(/login /logout /signup /css/bootstrap.min.css).include? request.path_info
  end

  get '/application.css' do
    sass :application
  end

  get '/application.js' do
    coffee :application
  end

  get '/' do
    #login_required
    @categories = Category.all
    haml :home
  end

  get '/store_selection' do
    @companies = Company.all
    haml :store_selection
  end

end
