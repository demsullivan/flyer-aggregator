Dir[File.expand_path('./lib/tasks/*.rake')].each {|f| load f }
require 'sinatra/activerecord/rake'
require './application.rb'

desc "Console"
task :console do
  require 'bundler/setup'
  Bundler.require :default
  exec "irb -I./lib -r stores -r sinatra/activerecord"
end
