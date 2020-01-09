class WagonCargo < Wagon
  attr_reader :free_capacity
  def initialize(id, capacity)
    super(id)
    @type = 'Грузовой'
    @capacity = capacity
    @free_capacity = capacity
  end

  def load(cargo_volume)
    @free_capacity -= cargo_volume
  end

  def occupied_capacity
    @capacity - @free_capacity
  end
end
