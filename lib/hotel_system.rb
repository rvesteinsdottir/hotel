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
      # reservation_dates = convert_to_range(start_date, end_date)
      
      # available_room_id = find_rooms(reservation_dates).first.to_i
      
      available_room_id = find_rooms(start_date, end_date).first.to_i
      
      new_reservation = Hotel::Reservation.new(start_date, end_date, available_room_id)
      
      #CHANGE THIS
      # adds new reservation object reservations list and selected room
      @reservations << new_reservation
      @rooms[available_room_id - 1].dates_reserved << [start_date, end_date]
      
      # new_reservation.date_range.each do |date|
      #   @rooms[available_room_id - 1].dates_reserved << date
      # end
      
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
    
    #CHANGE THIS
    # need to change based on dates reversal
    def find_available_rooms(start_date, end_date)
      if end_date != nil
        available_rooms = find_rooms(start_date, end_date)
      else
        available_rooms = @rooms.reject do |room|     
          busy_rooms = room.dates_reserved.select do |dates| 
            dates[0] <= start_date && start_date < dates[1]
          end
          
          busy_rooms != []
        end
      end
      # date_range = convert_to_range(start_date, end_date)
      # if date_range.length == 1
      #   available_rooms = @rooms.select do |room|
      #     room.id unless room.dates_reserved.include?(date_range[0])
      #   end
      # else
      #   available_rooms = find_rooms(date_range)
      # end
      
      return available_rooms
    end
    
    def find_rooms(start_date, end_date)     
      available_rooms = []
      
      
      
      # DOES NOT WORK FOR RESERVATIONS MADE AFTER FIRST RES (ie scheduling 8/29-9/1 after scheduling 9/15-9/16)
      @rooms.each do |room|
        room.dates_reserved.sort_by{|res_dates| res_dates[1]}
        
        if room.dates_reserved == [] 
          available_rooms << room.id
        else       
          available = 0   
          room.dates_reserved.each_with_index do |res_date, i|
            if start_date < res_date[0] && end_date <= res_date[0]
              available += 1
            elsif start_date >= res_date[1] && end_date > res_date[1]
              available += 1
            end
            
            # # if available == true
            # #   if res_date[0] >= end_date
            # #     available_rooms << room.id
            # #     available = false
            # #   end
            # elsif res_date[1] <= start_date && i == (room.dates_reserved.length - 1)
            #   available_rooms << room.id
            # elsif res_date[1] >= start_date
            #   available = true
            # end
            
          end
          
          if available == room.dates_reserved.length
            available_rooms << room.id
          end
        end
        
        
        
        # if room.dates_reserved == [] || start_date >= room.dates_reserved.last[1] || end_date < room.dates_reserved.first[0]
        #   available_rooms << room.id
        # end
      end
      
      
      
      # available_rooms = {}
      # @rooms.each do |room|
      #   available_rooms["#{room.id}"] = 0
      # end
      
      # date_range.each do |date|
      #   @rooms.each do |room|
      #     if room.dates_reserved.include?(date) # && date < ( date_range.length - 1 )
      #       available_rooms["#{room.id}"] += 1 
      #     else
      #       available_rooms["#{room.id}"] += 0
      #     end
      #   end
      # end
      
      # available_rooms.select!{|k,v| v == 0}
      
      return available_rooms unless available_rooms == []
      
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