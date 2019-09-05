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
      reservation_dates = convert_to_range(start_date, end_date)
      
      available_room_id = find_rooms(reservation_dates).first.to_i
      
      new_reservation = Hotel::Reservation.new(reservation_dates, available_room_id)
      
      # adds new reservation object reservations list and selected room
      @reservations << new_reservation
      new_reservation.date_range.each do |date|
        @rooms[available_room_id - 1].dates_reserved << date
      end
      
      return new_reservation
    end
    
    def find_reservations(date)
      res_on_date = @reservations.select do |reservation|
        reservation.date_range.include?(date)
      end
      
      return res_on_date
    end
    
    def find_available_rooms(start_date, end_date = nil)
      date_range = convert_to_range(start_date, end_date)
      if date_range.length == 1
        available_rooms = @rooms.select do |room|
          room.id unless room.dates_reserved.include?(date_range[0])
        end
      else
        available_rooms = find_rooms(date_range)
      end
      
      return available_rooms
    end
    
    def find_rooms(date_range)      
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
      
      return available_rooms.keys unless available_rooms == {}
      
      raise ArgumentError, "No rooms available at this time"
    end
    
    def convert_to_range(start_date, end_date)
      date_range = []
      if end_date == nil
        date_range << start_date
      else
        res_length = (end_date - start_date).to_i
        res_length.times do |i|
          date_range << (start_date + i) 
        end
      end
      
      return date_range
    end
  end
end