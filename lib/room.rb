module Hotel
  class Room
    
    attr_reader :id, :rate
    attr_accessor :dates_reserved
    
    def initialize(id)
      @id = id
      @dates_reserved = []
      @blocks_reservation = []
    end
  end
end