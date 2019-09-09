require_relative 'test_helper'

describe "Room class" do
  
  describe "initializer" do
    before do
      @room = Hotel::Room.new(7)
    end
    
    it "is an instance of room" do
      expect(@room).must_be_kind_of Hotel::Room
    end
    
    it "creates new instance of room with correct room id" do
      expect(@room.id).must_equal 7
      expect(@room.dates_reserved).must_equal []
      expect(@room.blocks).must_equal []
    end
  end
  
end