module Hotel
  class Room
    
    attr_reader :id, :rate
    attr_accessor :dates_reserved
    
    def initialize(id, rate = 200)
      @id = id
      @rate = rate
      @dates_reserved = []
      @blocks_reservation = []
    end
  end
end