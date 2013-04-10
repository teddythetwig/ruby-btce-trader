require './lib/algorithm.rb'
require './lib/runner.rb'
require 'btce'
require 'active_record'
module BtceTrader
  dbconfig = YAML::load(File.open('database.yml'))
  ActiveRecord::Base.establish_connection(dbconfig)
end
