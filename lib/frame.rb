# This class wraps all the data that happened from time start to time end
# it can hold all types of data that can be pulled from btc-e.com
# 
#
#
module BtceTrader
  class Frame < ActiveRecord::Base
    has_many :trades
    has_one :tickers
    #to be implemented      
    
    #has_one :depth
    #has_one :someothershit
    attr_accessible :start, :end, :pair, :frame_id
  
  end
end
