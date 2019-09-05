require_relative 'room'

module Hotel
  class Reservation
    attr_reader :cost, :date_range, :room_id
    
    def initialize(date_range, room_id)
      @date_range = date_range
      
      raise ArgumentError unless date_range.first.class == Date && date_range.last.class == Date
      
      @cost = ((date_range.last - date_range.first) * 200).to_f
      
      @room_id = room_id
    end
  end
end