require 'bundler/setup'
Bundler.require(:default)
 
require File.dirname(__FILE__) + "/app.rb"
require File.dirname(__FILE__) + "/lib/partials.rb"
require File.dirname(__FILE__) + "/lib/poll_serializer.rb"
require 'data_mapper'
require "dm-core"
require "dm-validations"
require "dm-accepts_nested_attributes"

DataMapper.setup(:default, 'postgres://localhost/pollerr')
DataMapper.finalize.auto_upgrade!
 
map '/' do
  run CORE::App
end