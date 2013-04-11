module BtceTrader
  class Ticker < ActiveRecord::Base
    belongs_to :frame
  end
end
