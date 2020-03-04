require_relative 'test_helper'
require_relative '../lib/date_range'
require 'date'

describe "front desk" do
  before do
    @front_desk = Hotel::FrontDesk.new
  end

  describe "self.rooms" do
  
    it "stores all 20 hotel rooms" do
      expect(@front_desk.rooms.count).must_equal 20
    end

    it "returns an array of the 20 rooms" do
      expect(@front_desk.rooms).must_be_instance_of Array
    end

    it "stores instances of the Room class inside the array" do
      expect(@front_desk.rooms.sample).must_be_instance_of Hotel::Room
      expect(@front_desk.rooms.sample).must_be_instance_of Hotel::Room
      expect(@front_desk.rooms.sample).must_be_instance_of Hotel::Room
    end
  end

  describe "find_room" do
    before do
      @front_desk = Hotel::FrontDesk.new
    end

    it "finds an instance of a room given the room number" do
      room_number = 4
      expect(@front_desk.find_room(room_number)).must_be_instance_of Hotel::Room
    end
  end

  describe "add_reservation" do
    before do
      @dates = Hotel::DateRange.new(start_date: Date.new(2020, 3, 4), end_date: Date.new(2020, 3, 7))
      @front_desk.add_reservation(@dates)
    end

    it "adds date range to front desk date range instance variable array" do
      expect(@front_desk.date_ranges[0]).must_be_instance_of Hotel::DateRange
    end
    
    it "adds an id to the reservation" do
      expect(@front_desk.reservations[0].id).must_be_instance_of Integer
    end

    it "adds an instance of the room class to the reservation" do
      expect(@front_desk.reservations[0].room).must_be_instance_of Hotel::Room
    end

    it "adds a reservation object to collection of reservations" do
      expect(@front_desk.reservations[0]).must_be_instance_of Hotel::Reservation
    end

    it " adds the reservation to the room object" do
      expect(@front_desk.reservations[0].room.reservations[0]).must_be_instance_of Hotel::Reservation
    end

  end

  describe "available_rooms" do
    before do
      @dates = Hotel::DateRange.new(start_date: Date.new(2020, 3, 4), end_date: Date.new(2020, 3, 7))
      @front_desk.add_reservation(@dates)
    end

    it "returns an array of all available rooms given a date range" do
      expect(@front_desk.available_rooms(@dates)).must_be_instance_of Array
    end

    it "has room objects contained in the array" do
      expect(@front_desk.available_rooms(@dates).sample).must_be_instance_of Hotel::Room
    end

    it "returns array of rooms that doesn't include any rooms that are booked for same date range" do
      expect(@front_desk.available_rooms(@dates).count).must_equal 19
      expect(@front_desk.available_rooms(@dates)[0].room_number).must_equal 2
    end
  end

  describe "find_reservation_with" do
    before do
      @dates = Hotel::DateRange.new(start_date: Date.new(2020, 3, 4), end_date: Date.new(2020, 3, 7))
      @room = @front_desk.rooms[0]
    end

    it "returns an array of reservations that match the date" do
      expect(@front_desk.find_reservation_with(room: @room, date_range: @dates)).must_be_instance_of Array
    end

    it "returns an empty array if there are no reservations" do
      expect(@front_desk.find_reservation_with(room: @room, date_range: @dates).sample).must_equal nil
    end

    it "returns reservations if there are reservations for given room and date range" do
      @front_desk.add_reservation(@dates)
      expect(@front_desk.find_reservation_with(room: @room, date_range: @dates).sample).must_be_instance_of  Hotel::Reservation 
    end

    it "returns reservations if there are reservations for given date range" do
      @front_desk.add_reservation(@dates)
      expect(@front_desk.find_reservation_with(date_range: @dates).sample).must_be_instance_of  Hotel::Reservation 
    end

  end
end