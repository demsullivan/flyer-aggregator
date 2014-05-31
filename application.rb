require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/activerecord'

Dir[File.expand_path('./lib/*.rb')].each {|f| require f }
Dir[File.expand_path('./models/*.rb')].each {|f| require f }

class Website < Sinatra::Base
  root_dir = File.dirname(__FILE__)

  register Sinatra::ActiveRecordExtension
  
  set :environment, ENV['RACK_ENV'] || :development
  set :root, root_dir
  set :app_file, __FILE__
  set :static, true

  helpers do
    include Helpers
  end

  before do
    # @var = blah
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

end
