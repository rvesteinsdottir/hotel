require 'date'

require_relative 'room'
require_relative 'reservation'
require_relative 'block'

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
      room_numbers.each do |room_id|
        @rooms[room_id - 1].blocks << {block_start: start_date, block_end: end_date}
      end
    end
    
    def make_reservation_from_block(start_date, end_date, room_id)
      room_available = false
      discounted_cost = 0
      
      @blocks.each do |block|
        if block.available_room_numbers.include?(room_id)
          raise ArgumentError, "You can only reserve this room for the full duration of the block" unless block.start_date == start_date && block.end_date == end_date
          
          room_available = true
          discounted_cost = block.cost
        end
        block.available_room_numbers.delete(room_id)
      end
      
      raise ArgumentError, "The room you requested is not available" unless room_available == true 
      
      new_reservation = Hotel::Reservation.new(start_date, end_date, room_id)
      new_reservation.cost = discounted_cost
      
      @reservations << new_reservation
      @rooms[room_id - 1].dates_reserved << {reservation_start: start_date, reservation_end: end_date}
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
        if room.dates_reserved == [] && room.blocks == []
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
          
          # removes from list of available rooms if room has block reservation
          if room.blocks != []
            room.blocks.each do |block_reservation|
              if start_date < block_reservation[:block_start] && end_date <= block_reservation[:block_start]
                available += 1
              elsif start_date >= block_reservation[:block_end] && end_date > block_reservation[:block_end]
                available += 1
              end
            end
          end
          
          if available == (room.dates_reserved.length + room.blocks.length)
            available_rooms << room.id
          end
        end
      end
      
      return available_rooms unless available_rooms == []
      
      raise ArgumentError, "No rooms available at this time"
    end
  end
end