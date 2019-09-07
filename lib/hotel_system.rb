require 'date'

require_relative 'room'
require_relative 'reservation'

module Hotel
  class HotelSystem
    attr_reader :rooms, :reservations, :blocks
    
    def initialize
      @rooms = []
      20.times do |i|
        @rooms << Hotel::Room.new((i + 1))
      end
      
      @reservations = []
      @blocks = []
    end
    
    def make_reservation(start_date, end_date)
      available_room_id = find_available_rooms(start_date, end_date).first.to_i
      
      new_reservation = Hotel::Reservation.new(start_date, end_date, available_room_id)
      
      @reservations << new_reservation
      @rooms[available_room_id - 1].dates_reserved << {reservation_start: start_date, reservation_end: end_date}
      
      return new_reservation
    end
    
    def create_block(start_date, end_date, room_numbers, discounted_rate)
      room_numbers.each do |room_id|
        raise ArgumentError, "Room #{room_id} not available for given date range" unless find_available_rooms(start_date, end_date).include?(room_id)
      end
      
      new_block = Hotel::Block.new(start_date, end_date, room_numbers, discounted_rate)
      
      @blocks << new_block
    end
    
    def make_reservation_from_block(start_date, end_date, room_id)
      # do I need a block id?
      # raise exception if start and end date do not match
      # raise exception if ID does not match
      
      # add to room list in same format as res
      # add to blocks list
    end
    
    # Does not list reservations that are on their final day
    def list_reservations(date)
      res_on_date = @reservations.select do |reservation|
        date >= reservation.start_date && date < reservation.end_date
      end
      
      return res_on_date
    end
    
    # A room is open if a reservation is on its final day
    def list_available_rooms(date)
      available_rooms = []
      @rooms.each do |room|  
        if room.dates_reserved == [] 
          available_rooms << room.id
        else 
          room.dates_reserved.each do |reservation|
            if date < reservation[:reservation_start] && date <= reservation[:reservation_end]
              available_rooms << room.id
            elsif date > reservation[:reservation_start]  && date >= reservation[:reservation_end]
              available_rooms << room.id
            end
          end
        end
      end
      
      return available_rooms
    end
    
    #NEED THIS TO INCLUDE BLCOKS
    def find_available_rooms(start_date, end_date)    
      available_rooms = []
      
      @rooms.each do |room|          
        if room.dates_reserved == [] 
          available_rooms << room.id
        else       
          available = 0   
          room.dates_reserved.each do |reservation|
            if start_date < reservation[:reservation_start] && end_date <= reservation[:reservation_start]
              available += 1
            elsif start_date >= reservation[:reservation_end] && end_date > reservation[:reservation_end]
              available += 1
            end
          end
          
          unless room.blocks == []
            room.blocks.each do |block_reservation|
              if start_date < block_reservation[:reservation_start] && end_date <= block_reservation[:reservation_start]
                available -= 1
              elsif start_date >= block_reservation[:reservation_end] && end_date > block_reservation[:reservation_end]
                available -= 1
              end
            end
          end
          
          if available == room.dates_reserved.length
            available_rooms << room.id
          end
        end
      end
      
      return available_rooms unless available_rooms == []
      
      raise ArgumentError, "No rooms available at this time"
    end
  end
end