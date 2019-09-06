require_relative 'test_helper'

describe "Reservation class" do
  
  describe "Reservation instantiation" do
    before do
      @room_test = 7
      
      @reservation_test = Hotel::Reservation.new(Date.new(2019,9,1), Date.new(2019,9,3), @room_test)
    end
    
    it "is an instance of reservation" do
      expect(@reservation_test).must_be_kind_of Hotel::Reservation
    end
    
    it "reservation has start date and end date of instance of date" do
      expect(@reservation_test.start_date).must_be_kind_of Date
      expect(@reservation_test.end_date).must_be_kind_of Date
    end
    
    it "adds cost variable with cost of reservation" do
      expect(@reservation_test.cost).must_equal 400.0
    end
  end
  
  describe "Validates date range" do
    before do
      @room_test = 7
    end
    
    it "raises argument error when given invalid date format" do
      expect{ 
        Hotel::Reservation.new(Date.new(2019,9,1), "2019/09/03", @room_test)
      }.must_raise ArgumentError
      
      expect{ 
        Hotel::Reservation.new("2019/09/01", Date.new(2019,9,3), @room_test)
      }.must_raise ArgumentError
    end
    
    it "raises argument error when end date is before or equal to start date" do
      expect{
        Hotel::Reservation.new(Date.new(2019,9,1), Date.new(2019,8,30), @room_test)
      }.must_raise ArgumentError
      
      expect{
        Hotel::Reservation.new(Date.new(2019,9,1), Date.new(2019,9,1), @room_test)
      }.must_raise ArgumentError
    end    
  end
end