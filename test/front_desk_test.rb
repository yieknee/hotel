require_relative 'test_helper'

describe "front desk" do
  before do
    @front_desk = Hotel::FrontDesk.new
    @dates = Hotel::DateRange.new(start_date: Date.today + 2, end_date: Date.today + 6)
  end

  describe "initialize FrontDesk" do
    
    it "creates a FrontDesk object" do
      expect(@front_desk).must_be_instance_of Hotel::FrontDesk
    end
    
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

  describe "add_reservation" do
    before do
      @front_desk.add_reservation(@dates)
    end

    it "raises exception when there are no available rooms for a given date range" do
      19.times do
        @front_desk.add_reservation(@dates)
      end

      expect{@front_desk.add_reservation(@dates)}.must_raise NoAvailableRoomError 
      
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

    it "returns an array of all available rooms given a date range" do
      expect(@front_desk.available_rooms(@dates)).must_be_instance_of Array
    end

    it "has room objects contained in the array" do
      expect(@front_desk.available_rooms(@dates).sample).must_be_instance_of Hotel::Room
    end

    it "returns array of all rooms for a given date range if no reservations exist for any room" do
      expect(@front_desk.available_rooms(@dates).count).must_equal 20
      expect(@front_desk.available_rooms(@dates)[0].room_number).must_equal 1
    end

    it "returns array of all rooms for a given date range that don't overlap the date range" do
      @front_desk.add_reservation(@dates)
      expect(@front_desk.available_rooms(@dates).count).must_equal 19
      expect(@front_desk.available_rooms(@dates)[0].room_number).must_equal 2

      @front_desk.add_reservation(@dates)

      expect(@front_desk.available_rooms(@dates).count).must_equal 18
      expect(@front_desk.available_rooms(@dates)[0].room_number).must_equal 3

      new_dates = Hotel::DateRange.new(start_date: Date.today + 6, end_date: Date.today + 10)
      @front_desk.add_reservation(new_dates)

      expect(@front_desk.available_rooms(@dates).count).must_equal 18
      expect(@front_desk.available_rooms(@dates)[0].room_number).must_equal 3

      test_dates = Hotel::DateRange.new(start_date: Date.today + 1, end_date: Date.today + 2)
      expect(@front_desk.available_rooms(test_dates).count).must_equal 20
      expect(@front_desk.available_rooms(test_dates)[0].room_number).must_equal 1
    end    

  end

  describe "find_reservation_with" do
    before do
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

  describe " total_cost" do
    before do
      @new_reservation = Hotel::Reservation.new(date_range: Hotel::DateRange.new(start_date: Date.today + 2, end_date: Date.today + 5), room: Hotel::Room.new(room_number: 1, cost: 200))
    end

    it "calculates total cost of the reservation " do
      expect(@front_desk.total_cost(@new_reservation)).must_equal 600
    end
  end

  describe "request_block" do
    before do
      @block_count = 3
      @discount_cost = 180
    end

    it "reserves the correct number of rooms for the hotel block for given date range" do
      @front_desk.request_block( @block_count, @dates, @discount_cost)

      expect(@front_desk.hotel_blocks[0].rooms.count).must_equal 3
      # expect(Hotel::HotelBlock.new(block_count: 2, date_range: @dates).rooms.count).must_equal 2
      # expect(Hotel::HotelBlock.new(block_count: 4, date_range: @dates).rooms.count).must_equal 4
      # expect(Hotel::HotelBlock.new(block_count: 5, date_range: @dates).rooms.count).must_equal 5
    
    end

    it " raises exception if there aren't enough rooms to fill block for given date range" do
      19.times do
        @front_desk.add_reservation(@dates)
      end

      expect{@front_desk.request_block(@block_count, @dates, @discount_cost)}.must_raise NoAvailableRoomError 

    end
  
  end

end