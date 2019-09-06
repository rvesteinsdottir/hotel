require_relative 'test_helper'

describe "Room class" do
  
  describe "Room instantiation" do
    it "is an instance of room" do
      room = Hotel::Room.new(1)
      
      expect(room).must_be_kind_of Hotel::Room
    end
  end
  
end