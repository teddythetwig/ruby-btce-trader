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
          #this is gettinge messy
          
          ActiveRecord::Base.transaction do
            if operation == "trades"
              slice_index = response.rindex{|trade| !(((time.to_i - INTERVAL)..time.to_i) === trade["date"].to_i) }
              puts slice_index
              slice_index = response.size if slice_index.nil?
              trades = response.first(slice_index + 1)
              puts "Size of new trades is #{trades.size}"
              puts "Range: #{time.to_i - INTERVAL} - #{time.to_i}"
              puts "First:#{trades.last['date']}"
              puts "Last:#{trades.first['date']}"
              trades.each do |trade|
                new_frame.trades.create(trade)
                
              end
              
            elsif operation == "ticker"
              ticker = response[operation]
              #new_frame.tickers.create(ticker)
            end
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
