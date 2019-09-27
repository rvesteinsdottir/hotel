require 'date'

require_relative 'room'
require_relative 'reservation'
require_relative 'block'

module Hotel
  class HotelSystem
    attr_reader :rooms, :reservations, :blocks
    
    def initialize
      @rooms = []
      @reservations = []
      @blocks = []
      
      20.times do |i|
        @rooms << Room.new(i + 1)
      end
    end
    
    def make_reservation(start_date, end_date, room_id = nil)
      if room_id == nil
        room_id = find_available_rooms(start_date, end_date).first.to_i 
      end
      
      new_reservation = Reservation.new(start_date, end_date, room_id)
      
      @reservations << new_reservation
      
      @rooms[room_id - 1].add_reservation(start_date, end_date)
    end
    
    def create_block(start_date, end_date, room_numbers, discounted_rate)
      room_numbers.each do |room_id|
        raise ArgumentError, "Room #{room_id} not available for given date range" unless find_available_rooms(start_date, end_date).include?(room_id)
      end
      
      new_block = Block.new(start_date, end_date, room_numbers, discounted_rate)
      
      @blocks << new_block
      room_numbers.each do |room_id|
        @rooms[room_id - 1].add_block(start_date, end_date)
      end
    end
    
    def make_reservation_from_block(start_date, end_date, room_id)
      room_available = false
      discounted_cost = 0
      
      @blocks.each do |block|
        if block.room_available?(room_id)
          raise ArgumentError, "You can only reserve this room for the full duration of the block" unless block.start_date == start_date && block.end_date == end_date
          
          room_available = true
          discounted_cost = block.cost
        end
        
        block.mark_unavailable(room_id)
      end
      
      raise ArgumentError, "The room you requested is not available" unless room_available == true 
      
      make_reservation(start_date, end_date, room_id)
      
      @reservations.last.update_cost(discounted_cost)
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
      available_room_ids = []
      @rooms.each do |room|  
        if room.dates_reserved == [] 
          available_room_ids << room.id
        else 
          room.dates_reserved.each do |reservation|
            if date < reservation[:start] && date <= reservation[:end]
              available_room_ids << room.id
            elsif date > reservation[:start]  && date >= reservation[:end]
              available_room_ids << room.id
            end
          end
        end
      end
      
      return available_room_ids
    end
    
    def check_reservation_conflicts(start_date, end_date, reservation_type, num_available_rooms)
      if start_date < reservation_type[:start] && end_date <= reservation_type[:start]
        num_available_rooms += 1
      elsif start_date >= reservation_type[:end] && end_date > reservation_type[:end]
        num_available_rooms += 1
      end
      
      return num_available_rooms
    end
    
    # Returns a list of available room_ids
    def find_available_rooms(start_date, end_date)    
      available_room_ids = []
      
      @rooms.each do |room|          
        if room.dates_reserved == [] && room.blocks == []
          available_room_ids << room.id
        else       
          num_available_rooms = 0   
          room.dates_reserved.each do |reservation|
            num_available_rooms += check_reservation_conflicts(start_date, end_date, reservation, num_available_rooms)
          end
          
          if room.blocks != []
            room.blocks.each do |block|
              num_available_rooms += check_reservation_conflicts(start_date, end_date, block, num_available_rooms)
            end
          end
          
          if num_available_rooms == (room.dates_reserved.length + room.blocks.length)
            available_room_ids << room.id
          end
        end
      end
      
      return available_room_ids unless available_room_ids == []
      
      raise ArgumentError, "No rooms available at this time"
    end
  end
end
