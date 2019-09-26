module Hotel
  class Room
    attr_reader :id, :rate
    attr_accessor :dates_reserved, :blocks
    
    def initialize(id)
      @id = id
      @dates_reserved = []
      @blocks = []
    end
    
    def add_reservation(start_date, end_date)
      @dates_reserved << {start: start_date, end: end_date}
    end
    
    def add_block(start_date, end_date)
      @blocks << {start: start_date, end: end_date}
    end
  end
end
