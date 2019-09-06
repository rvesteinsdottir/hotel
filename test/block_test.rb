require_relative 'test_helper'

describe "Block class" do
  describe "Initializer" do
    before do
      room_test = [7,9,11]
      
      @block_test = Hotel::Block.new(Date.new(2019,9,1), Date.new(2019,9,3), room_test)
    end    
    
    it "is an instance of block" do
      expect(@block_test).must_be_kind_of Hotel::Block
    end
    
    it "creates new instance of block with correct room numbers and cost" do
      expect(@block_test.room_numbers).must_equal [7,9,11]
      expect(@block_test.cost_per_rm).must_equal 380.0
      expect(@block_test.start_date).must_equal Date.new(2019,9,1)
      expect(@block_test.end_date).must_equal Date.new(2019,9,3)
      expect(@block_test.available_room_numbers).must_equal [7,9,11]
    end
  end
end