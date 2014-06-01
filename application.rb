require 'bundler/setup'
Bundler.require :default
require 'sinatra/base'

Dir[File.expand_path('./lib/*.rb')].each {|f| require f }
Dir[File.expand_path('./models/*.rb')].each {|f| require f }

class Website < Sinatra::Base
  root_dir = File.dirname(__FILE__)

  register Sinatra::ActiveRecordExtension
  register Sinatra::Bootstrap::Assets
  register Sinatra::SimpleAuthentication

  set :environment, ENV['RACK_ENV'] || :development
  set :root, root_dir
  set :app_file, __FILE__
  set :static, true

  helpers do      
    include Helpers
  end

  before do
    login_required unless %w(/login, /logout, /signup).include? request.path_info
  end

  get '/application.css' do
    sass :application
  end

  get '/application.js' do
    coffee :application
  end

  get '/' do
    @categories = Category.all
    haml :home
  end

  get '/store_selection' do
    @companies = Company.all
    haml :store_selection
  end

end
