require '../ruby-btce/lib/btce.rb'
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
        #each step represents one and a half minutes on btce
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

  class Runner
    @@last_trade_id=0
    WINDOW_SIZE = 86400/20 #frames
    INTERVAL = 20 #seconds

    def self.update_data
      time = Time.now
      puts "Updating data at #{time}"
      data ={}
      Algorithm::PAIRS.each do |pair|
        data[pair]={}
        Algorithm::OPERATIONS.each do |operation|
          #this is getting messy
          if operation == "trades"
            #have to filter out the trades that did not happen in this frame
            trades = Btce::PublicAPI.get_pair_operation_json(pair,operation)
            slice_index = trades.rindex{|trade|trade["tid"] > @@last_trade_id}
            slice_index = trades.size if slice_index.nil?
            data[pair][operation] = trades.first(slice_index + 1)              
            @@last_trade_id = data[pair][operation].first["tid"] if !data[pair][operation].first.nil?
            CSV.open("trades.csv","wb") do |csv|
              data[pair][operation].reverse.each do |trade|
                csv << trade.values
              end
            end
          else
            data[pair] =  Btce::PublicAPI.get_pair_operation_json(pair,operation)
          end
          
        end
        if $data_window.size >= WINDOW_SIZE
          $data_window.shift
        end
        $data_window << data.clone
      end
      puts "Took #{Time.now - time}s to pull data"
      puts "Most recent tid #{@@last_trade_id}"
      puts "\n"
    end
  
    def self.run
      previous_time = Time.new(0)
      algorithms = [Algorithm]
      while Time.now.to_i % INTERVAL != 0
        ;
      end
      while true
        #get data
        update_data
        #pass data to algorithm
        algorithms.each{|c| c.step}
        #sleep until next round
        sleep(INTERVAL - Time.now.to_i % INTERVAL)
      end
    end
  end
end
