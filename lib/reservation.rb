require_relative 'room'

module Hotel
  class Reservation
    attr_reader :cost, :date_range, :room_id
    
    def initialize(date_range, room_id)
      raise ArgumentError unless date_range.first.class == Date && date_range.last.class == Date
      
      #no longer needed
      #raise ArgumentError unless (date_range.last - date_range.first) > 0
      
      @date_range = date_range
      
      @cost = ((date_range.last - date_range.first) * 200).to_f
      
      @room_id = room_id
    end
    
    # def create_date_range(start_date, end_date)
    #   res_length = (end_date - start_date).to_i
    #   res_length.times do |i|
    #     @date_range << (start_date + i)
    #   end
    # end
    
  end
end