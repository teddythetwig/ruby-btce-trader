#first load required gems
require 'btce'
require 'active_record'

#then load all the files in /lib
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

module BtceTrader
  dbconfig = YAML::load(File.open('database.yml'))
  ActiveRecord::Base.establish_connection(dbconfig)
end
