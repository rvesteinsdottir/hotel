require 'date'

require_relative 'room'
require_relative 'reservation'

module Hotel
  class HotelSystem
    attr_reader :rooms
    
    def initialize
      @rooms = []
      20.times do |i|
        @rooms << Hotel::Room.new((i + 1), 200)
      end
      
      @reservations = []
    end
    
    def make_reservation(start_date, end_date)
      room_id = rand(1..20)
      
      new_reservation = Hotel::Reservation.new(start_date, end_date, room_id)
      
      new_reservation.date_range.each do |date|
        rooms[room_id -1].dates_reserved << date
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
        room.dates_reserved.include?(date)
      end
      
      return available_rooms
    end
    
  end
end