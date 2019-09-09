require_relative 'test_helper'

describe "HotelSystem class" do
  
  describe "initializer" do
    before do
      @system = Hotel::HotelSystem.new
    end
    
    it "is an instance of HotelSystem class" do
      expect(@system).must_be_kind_of Hotel::HotelSystem
    end
    
    
    it "establishes list of 20 rooms when instantiated" do
      expect(@system.rooms.length).must_equal 20
    end
    
    it "creates instance of room in room list" do
      expect(@system.rooms.first).must_be_instance_of Hotel::Room
      expect(@system.rooms.first.id).must_equal 1
      expect(@system.rooms.last).must_be_instance_of Hotel::Room
    end
  end
  
  describe "make_reservation" do
    before do
      @system = Hotel::HotelSystem.new
    end
    
    it "adds an instance of reservation to reservation list" do
      expect(@system.reservations.length).must_equal 0
      
      @system.make_reservation(Date.new(2019,9,1), Date.new(2019,9,3))
      
      expect(@system.reservations.length).must_equal 1
      expect(@system.reservations.last.start_date).must_equal Date.new(2019,9,1)
    end
    
    it "adds reservation to 'dates_reserved' variable for the assigned room" do
      expect(@system.rooms[0].dates_reserved).must_equal []
      
      @system.make_reservation(Date.new(2019,9,1), Date.new(2019,9,3))
      
      expect(@system.rooms[0].dates_reserved[0][:start]).must_equal Date.new(2019,9,1)
    end
    
    it "exception is raised if no available rooms in date range" do
      20.times do
        @system.make_reservation(Date.new(2019,9,1), Date.new(2019,9,5))
      end
      
      expect{
        @system.make_reservation(Date.new(2019,9,1), Date.new(2019,9,5))
      }.must_raise ArgumentError
    end
  end
  
  describe "list_reservations" do
    before do
      @system = Hotel::HotelSystem.new
      
      @system.make_reservation(Date.new(2019,9,1), Date.new(2019,9,3))
      @system.make_reservation(Date.new(2019,9,3), Date.new(2019,9,4))
      @system.make_reservation(Date.new(2019,9,3), Date.new(2019,9,4))
    end
    
    it "returns a list of all reservations for a specific date" do
      expect(@system.list_reservations(Date.new(2019,9,3)).length).must_equal 2
      expect(@system.list_reservations(Date.new(2019,9,3)).first).must_be_kind_of Hotel::Reservation
      expect(@system.list_reservations(Date.new(2019,9,3)).last).must_be_kind_of Hotel::Reservation
    end
  end
  
  describe "list_available_rooms" do
    before do
      @system = Hotel::HotelSystem.new
      
      @system.make_reservation(Date.new(2019,9,1), Date.new(2019,9,5))
      @system.make_reservation(Date.new(2019,9,3), Date.new(2019,9,4))
    end
    
    it "returns a list of all rooms that are available for a specific date" do
      expect(@system.list_available_rooms(Date.new(2019,8,29)).length).must_equal 20
      expect(@system.list_available_rooms(Date.new(2019,9,3)).length).must_equal 18
      expect(@system.list_available_rooms(Date.new(2019,9,4)).length).must_equal 19
    end
  end
  
  describe "find_available_rooms" do
    before do
      @system = Hotel::HotelSystem.new
      
      @system.make_reservation( Date.new(2019,9,1), Date.new(2019,9,5))
      @system.make_reservation(Date.new(2019,9,3), Date.new(2019,9,4))
    end
    
    it "returns a list of all rooms that are available for an overlapping date range" do
      expect(@system.find_available_rooms(Date.new(2019,9,4),Date.new(2019,9,6)).length).must_equal 19
      expect(@system.find_available_rooms(Date.new(2019,8,19),Date.new(2019,9,16)).length).must_equal 18
    end
    
    it "returns a list of all rooms that are available for a date range before created reservations" do
      expect(@system.find_available_rooms(Date.new(2019,8,29),Date.new(2019,8,30)).length).must_equal 20
    end
    
    it "returns a list of all rooms that are available for a date range after created reservations" do
      expect(@system.find_available_rooms(Date.new(2019,9,19),Date.new(2019,9,16)).length).must_equal 20
    end
    
    it "a room that is part of block is not available" do 
      @system.create_block(Date.new(2019,9,1), Date.new(2019,9,5),[3,4,17,15], 190)
      
      expect(@system.find_available_rooms(Date.new(2019,9,1), Date.new(2019,9,5)).include?(4)).must_equal false
      expect(@system.find_available_rooms(Date.new(2019,9,1), Date.new(2019,9,5)).include?(18)).must_equal true
    end
  end
  
  describe "create_block" do
    before do
      @system = Hotel::HotelSystem.new
      @system.make_reservation( Date.new(2019,9,1), Date.new(2019,9,5))
      @system.make_reservation(Date.new(2019,9,3), Date.new(2019,9,4))
    end
    
    it "raises argument error if rooms not available" do
      expect{
        @system.create_block(Date.new(2019,9,3), Date.new(2019,9,4), [1,2,5], 190)
      }.must_raise ArgumentError
    end
    
    it "adds block to list of blocks" do
      expect(@system.blocks.length).must_equal 0
      
      @system.create_block(Date.new(2019,9,19), Date.new(2019,9,20), [1,2,5], 190)
      
      expect(@system.blocks.length).must_equal 1
    end
  end
  
  describe "reserve_from_block" do
    before do
      @system = Hotel::HotelSystem.new
      @system.create_block(Date.new(2019,9,3), Date.new(2019,9,4), [1,2,5], 190)
    end
    
    it "raises argument error if start and end date do not match start end of block with specific room" do
      expect{
        @system.make_reservation_from_block(Date.new(2019,9,2), Date.new(2019,9,4), 1)
      }.must_raise ArgumentError
    end
    
    it "raises argument error if room is not part of the block" do
      expect{
        @system.make_reservation_from_block(Date.new(2019,9,3), Date.new(2019,9,4), 15)
      }.must_raise ArgumentError
    end
    
    it "makes new reservation with start and end time at specific room" do
      expect(@system.reservations).must_equal []
      
      @system.make_reservation_from_block(Date.new(2019,9,3), Date.new(2019,9,4), 5)
      
      expect(@system.reservations.length).must_equal 1
      expect(@system.reservations[0].start_date).must_equal Date.new(2019,9,3)
      expect(@system.reservations[0].end_date).must_equal Date.new(2019,9,4)
      expect(@system.reservations[0].room_id).must_equal 5
      expect(@system.reservations[0].cost).must_equal 190.0
    end
    
    it "removes room id from 'available_rooms' associated with that block" do
      expect(@system.blocks[0].available_room_numbers).must_equal [1,2,5]
      
      @system.make_reservation_from_block(Date.new(2019,9,3), Date.new(2019,9,4), 5)
      
      expect(@system.blocks[0].available_room_numbers).must_equal [1,2]
    end
  end
end
