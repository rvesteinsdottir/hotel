require_relative 'room'

module Hotel
  class Reservation
    attr_reader :cost, :date_range, :room_id
    
    def initialize(start_date, end_date, room_id)
      raise ArgumentError unless start_date.class == Date && end_date.class == Date
      
      raise ArgumentError unless (end_date - start_date) >= 1
      
      @date_range = []
      create_date_range(start_date, end_date)
      
      @cost = ((end_date - start_date) * 200).to_f
      
      @room_id = room_id
    end
    
    def create_date_range(start_date, end_date)
      res_length = (end_date - start_date).to_i
      res_length.times do |i|
        @date_range << (start_date + i)
      end
    end
    
  end
end