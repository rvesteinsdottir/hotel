module Hotel
  class Block
    attr_reader :start_date, :end_date, :room_numbers, :cost, :available_room_numbers
    
    def initialize(start_date, end_date, room_numbers, discounted_rate)
      @start_date = start_date
      @end_date = end_date
      
      raise ArgumentError unless start_date.class == Date && end_date.class == Date
      
      raise ArgumentError if end_date <= start_date
      
      @room_numbers = room_numbers
      @available_room_numbers = room_numbers
      @cost = ((@end_date - @start_date) * discounted_rate).to_f
    end
  end
end