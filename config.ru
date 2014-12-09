require 'bundler/setup'
Bundler.require(:default)
 
require File.dirname(__FILE__) + "/app.rb"
require 'mongoid'
Mongoid.load!("config/mongoid.yml")

 
map '/' do
  run CORE::Main
end