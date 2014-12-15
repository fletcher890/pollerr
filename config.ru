require 'bundler/setup'
Bundler.require(:default)
 
require File.dirname(__FILE__) + "/app.rb"
require 'data_mapper'

DataMapper.setup(:default, 'postgres://localhost/pollerr')
DataMapper.finalize.auto_upgrade!
 
map '/' do
  run CORE::App
end