require 'date'

require_relative 'room'
require_relative 'reservation'

module Hotel
  class HotelSystem
    attr_reader :rooms, :reservations
    
    def initialize
      @rooms = []
      20.times do |i|
        @rooms << Hotel::Room.new((i + 1), 200)
      end
      
      @reservations = []
    end
    
    def make_reservation(start_date, end_date)
      available_room_id = find_available_rooms(start_date, end_date).first.to_i
      
      new_reservation = Hotel::Reservation.new(start_date, end_date, available_room_id)
      
      @reservations << new_reservation
      @rooms[available_room_id - 1].dates_reserved << {reservation_start: start_date, reservation_end: end_date}
      
      return new_reservation
    end
    
    #DOES IT WORK?
    #does not return reservations that have that day as an end date
    def find_reservations(date)
      res_on_date = @reservations.select do |reservation|
        date >= reservation.start_date && date < reservation.end_date
      end
      
      return res_on_date
    end
    
    def find_available_rooms(start_date, end_date)
      if end_date != nil        
        available_rooms = []
        
        @rooms.each do |room|          
          if room.dates_reserved == [] 
            available_rooms << room.id
          else       
            available = 0   
            room.dates_reserved.each_with_index do |res_date, i|
              if start_date < res_date[:reservation_start] && end_date <= res_date[:reservation_start]
                available += 1
              elsif start_date >= res_date[:reservation_end] && end_date > res_date[:reservation_end]
                available += 1
              end
            end
            
            if available == room.dates_reserved.length
              available_rooms << room.id
            end
          end
        end
        
        return available_rooms unless available_rooms == []
        
        raise ArgumentError, "No rooms available at this time"
      else
        # returns room instance rather than room_id
        #move to find_rooms?
        available_rooms = @rooms.reject do |room|     
          busy_rooms = room.dates_reserved.select do |dates| 
            dates[:reservation_start] <= start_date && start_date < dates[:reservation_end]
          end
          
          busy_rooms != []
        end
      end
      
      return available_rooms
    end
  end
end