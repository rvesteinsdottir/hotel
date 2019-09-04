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
      available_room_id = find_room(start_date, end_date)
      
      new_reservation = Hotel::Reservation.new(start_date, end_date, available_room_id)
      
      new_reservation.date_range.each do |date|
        rooms[available_room_id - 1].dates_reserved << date
      end
      
      @reservations << new_reservation
      
      return new_reservation
    end
    
    def find_reservations(date)
      res_on_date = @reservations.select do |reservation|
        reservation.date_range.include?(date)
      end
      
      return res_on_date
    end
    
    def find_available_rooms(date)
      available_rooms = @rooms.reject do |room|
        room.dates_reserved.include?(date) && (room.dates_reserved.index(date) < (room.dates_reserved.length - 1))
      end
      
      return available_rooms
    end
    
    def find_room(start_date, end_date)
      #stuck
      # no_reservations = @rooms.select { |room| room.dates_reserved == []}
      
      # return no_reservations.first if no_reservations != []
      
      res_length = (end_date - start_date + 1).to_i
      
      date_range = []
      
      res_length.times do |i|
        date_range << (start_date + i)
      end
      
      available_rooms = {}
      @rooms.each do |room|
        available_rooms["#{room.id}"] = 0
      end
      
      date_range.each do |date|
        @rooms.each do |room|
          if room.dates_reserved.include?(date) # && date < ( date_range.length - 1 )
            available_rooms["#{room.id}"] += 1 
          else
            available_rooms["#{room.id}"] += 0
          end
        end
      end
      
      available_rooms.select!{|k,v| v == 0}
      
      return available_rooms.keys.first.to_i unless available_rooms == {}
      
      raise ArgumentError, "No rooms available at this time"
    end
    
  end
end