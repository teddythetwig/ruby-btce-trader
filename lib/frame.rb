module BtceTrader
  class Frame < ActiveRecord::Base
    #has_many :trades
    #to be implemented      
    #has_one :ticker
    #has_one :depth
    #has_one :someothershit
    attr_accessible :start, :end, :pair
  end
end
