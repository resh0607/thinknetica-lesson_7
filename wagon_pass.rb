class WagonPass < Wagon
  attr_reader :free_seats
  def initialize(id, seats_quantity)
    super(id)
    @type = 'Пассажирский'
    @seats_quantity = seats_quantity
    @free_seats = seats_quantity
  end

  def take_seat
    @free_seats -= 1
  end

  def occupied_seats_quantity
    @seats_quantity - @free_seats
  end
end
