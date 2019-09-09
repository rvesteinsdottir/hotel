module Hotel
  class Room
    attr_reader :id, :rate
    attr_accessor :dates_reserved, :blocks
    
    def initialize(id)
      @id = id
      @dates_reserved = []
      @blocks = []
    end
  end
end
