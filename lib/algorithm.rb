
require 'csv'
module BtceTrader
  $data_window=[]
  class Algorithm
    #The pairs that this algorithm requires
    PAIRS = %w(ltc_usd)
    #The operations that this algorithm requires
    OPERATIONS = %w(ticker trades)
    class << self
      def initialize
        #do something here to setup the algorithm
        pass
      end
    
      def step
        #each step represents 20 seconds on btce
        #puts data
      end
      
      #Algorithm must use ticker to get this
      def vwap data, length, pair
        vwap = 0
        data.last(length).each do |d|
          
        end
      end
    end
  end
end
