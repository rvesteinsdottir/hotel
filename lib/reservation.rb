require_relative 'room'

module Hotel
  class Reservation
    attr_reader :cost, :start_date, :end_date, :room_id
    
    def initialize(start_date, end_date = nil, room_id)
      @start_date = start_date
      @end_date = end_date
      
      raise ArgumentError unless start_date.class == Date && end_date.class == Date
      
      raise ArgumentError if end_date <= start_date
      
      @cost = calculate_cost
      @room_id = room_id
    end
    
    def calculate_cost
      ((@end_date - @start_date -1) * 200).to_f
    end
  end
end