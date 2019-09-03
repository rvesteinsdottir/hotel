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
    
    it "returns instance of reservation when given start and end date" do
      start_d = Date.new(2019,9,1)
      end_d = Date.new(2019,9,3)
      expect(@system.make_reservation(start_d, end_d)).must_be_kind_of Hotel::Reservation
    end
    
    # it "marks room as 'reserved' when making reservation" do
    #   start_d = Date.new(2019,9,1)
    #   end_d = Date.new(2019,9,3)
    #   expect(@system.rooms.select{|room| room.status == "RESERVED"}).must_equal []
    
    #   @system.make_reservation(start_d, end_d)
    
    #   expect(@system.rooms.select{|room| room.status == "RESERVED"}.length).must_equal 1
    # end
  end
  
  describe "find_reservations" do
    before do
      @system = Hotel::HotelSystem.new
      
      @system.make_reservation( Date.new(2019,9,1), Date.new(2019,9,3))
      
      @system.make_reservation(Date.new(2019,9,3), Date.new(2019,9,4))
    end
    
    it "returns a list of all reservations for a specific date" do
      expect(@system.find_reservations(Date.new(2019,9,3)).length).must_equal 2
      expect(@system.find_reservations(Date.new(2019,9,3)).first).must_be_kind_of Hotel::Reservation
      expect(@system.find_reservations(Date.new(2019,9,3)).last).must_be_kind_of Hotel::Reservation
    end
  end
  
  describe "find_available_rooms" do
    before do
      @system = Hotel::HotelSystem.new
      @system.make_reservation( Date.new(2019,9,1), Date.new(2019,9,3))
      
      @system.make_reservation(Date.new(2019,9,3), Date.new(2019,9,4))
    end
    
    it "returns a list of all rooms that are available for a specific date" do
      available_date = Date.new(2019,9,3)
      expect(@system.find_available_rooms(Date.new(2019,8,29)).length).must_equal 20
      
      expect(@system.find_available_rooms(available_date).length).must_equal 18
    end
    
    
  end
end