require 'active_record'
require 'sqlite3'
module BtceTrader
  dbconfig = YAML::load(File.open('database.yml'))
  ActiveRecord::Base.establish_connection(dbconfig)
  ActiveRecord::Base.connection.drop_database(dbconfig['database']) rescue nil
  ActiveRecord::Base.connection.create_database(dbconfig['database']) rescue nil
  ActiveRecord::Base.establish_connection(dbconfig)
  class CreateFrames < ActiveRecord::Migration
    def self.up
      create_table :frames do |t|
        t.integer :start
        t.integer :end
        t.string :pair
        t.timestamps
      end
    end
    def self.down
      drop_table :frames
    end
  end
  class CreateTrades < ActiveRecord::Migration
  
    def self.up
      create_table :trades, :primary_key => :tid do |t|
        t.integer :date
        t.float :price
        t.float :amount
        t.integer :tid
        t.string :price_currency
        t.string :item
        t.string :trade_type
        t.integer :frame_id
        t.timestamps
      end
      add_index :trades, :date
    end
    def self.down
      drop_table :frames
    end
  end
  class CreateTickers < ActiveRecord::Migration
    create_table :tickers do |t|
      t.float :high
      t.float :low
      t.float :avg
      t.float :vol
      t.float :vol_cur
      t.float :last
      t.float :buy
      t.float :sell
      t.integer :server_time
      t.integer :frame_id
    end
  end   
  
  
  CreateFrames.up
  CreateTrades.up
  CreateTickers.up
 end
