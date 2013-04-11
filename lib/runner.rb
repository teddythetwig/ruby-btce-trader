module BtceTrader
  class Runner
    INTERVAL = 20 #seconds

    def self.update_data
      time = Time.now.localtime("+04:00")
      puts "Updating data at #{time}"
      Algorithm::PAIRS.each do |pair|
        new_frame = BtceTrader::Frame.create(:start => time.to_i - INTERVAL, :end => time.to_i, :pair => pair)
        Algorithm::OPERATIONS.each do |operation|
          response = Btce::PublicAPI.get_pair_operation_json(pair,operation)
          #this is getting messy
          if operation == "trades"
            slice_index = response.rindex{|trade|trade["tid"] > Trade.last.id}
            slice_index = response.size if slice_index.nil?
            trades = response.first(slice_index + 1) 
            ActiveRecord::Base.transaction do
              trades.each do |trade|
                new_frame.trades.create(trade)
              end
            end
          
            #have to filter out the trades that did not happen in this frame
            #trades = Btce::PublicAPI.get_pair_operation_json(pair,operation)
            #slice_index = trades.rindex{|trade|trade["tid"] > @@last_trade_id}
            #slice_index = trades.size if slice_index.nil?
            #data[pair][operation] = trades.first(slice_index + 1)              
            #@@last_trade_id = data[pair][operation].first["tid"] if !data[pair][operation].first.nil?
            #CSV.open("trades.csv","wb") do |csv|
              #data[pair][operation].reverse.each do |trade|
                #csv << trade.values
              #end
            #end
            
          else if operation == "ticker"
            #data[pair] =  Btce::PublicAPI.get_pair_operation_json(pair,operation)
            
            
            
            
            
            
            
          end 
        end
      end
      puts "Took #{Time.now - time}s to pull data"
      puts "\n"
    end
  
    def self.run
      puts "Starting BtceTrader"
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
