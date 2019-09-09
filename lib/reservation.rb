module Hotel
  class Reservation
    attr_accessor :cost
    attr_reader :start_date, :end_date, :room_id
    
    def initialize(start_date, end_date, room_id)
      @start_date = start_date
      @end_date = end_date
      
      raise ArgumentError unless start_date.class == Date && end_date.class == Date
      raise ArgumentError if end_date <= start_date
      
      @cost = ((@end_date - @start_date) * 200).to_f
      @room_id = room_id
    end
  end
end
