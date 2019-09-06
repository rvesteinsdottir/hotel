require_relative 'test_helper'

describe "Hotel System class" do
  
  describe "Initializer" do
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
      
      new_reservation = @system.make_reservation(Date.new(2019,9,1), Date.new(2019,9,3))
      
      expect(@system.reservations.last.room_id).must_equal new_reservation.room_id
      expect(@system.reservations.length).must_equal 1
    end
    
    it "adds reservation to 'dates_reserved' variable for the assigned room" do
      expect(@system.rooms[0].dates_reserved).must_equal []
      
      new_reservation = @system.make_reservation(Date.new(2019,9,1), Date.new(2019,9,3))
      
      expect(@system.rooms[0].dates_reserved[0][:reservation_start]).must_equal Date.new(2019,9,1)
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
      @system.make_reservation( Date.new(2019,9,1), Date.new(2019,9,5))
      
      @system.make_reservation(Date.new(2019,9,3), Date.new(2019,9,4))
    end
    
    it "returns a list of all rooms that are available for a specific date" do
      
      expect(@system.list_available_rooms(Date.new(2019,8,29)).length).must_equal 20
      expect(@system.list_available_rooms(Date.new(2019,9,3)).length).must_equal 18
      expect(@system.list_available_rooms(Date.new(2019,9,4)).length).must_equal 19
    end
  end
  
  describe "find_available_room" do
    before do
      @system = Hotel::HotelSystem.new
      @system.make_reservation( Date.new(2019,9,1), Date.new(2019,9,5))
      
      @system.make_reservation(Date.new(2019,9,3), Date.new(2019,9,4))
    end
    
    it "returns a list of all rooms that are available for an overlapping date range" do
      expect(@system.find_available_rooms(Date.new(2019,9,4),Date.new(2019,9,6)).length).must_equal 19
    end
    
    it "returns a list of all rooms that are available for a date range before reservations" do
      expect(@system.find_available_rooms(Date.new(2019,8,29),Date.new(2019,8,30)).length).must_equal 20
    end
    
  end
end