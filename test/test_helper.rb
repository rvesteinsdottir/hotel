require 'simplecov'
SimpleCov.start do
  add_filter 'test/'
end

require "minitest"
require "minitest/autorun"
require "minitest/reporters"
require 'date'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require_relative '../lib/hotel_system'
require_relative '../lib/room'
require_relative '../lib/reservation'
require_relative '../lib/block'