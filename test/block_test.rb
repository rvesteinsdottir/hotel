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
  end
end