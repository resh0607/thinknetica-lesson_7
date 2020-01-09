class Train 
  attr_reader :current_speed, :wagons, :current_station, :number, :type
  include Manufacturer
  include InstanceCounter
  @@trains = {}

  NUMBER_FORMAT = /^[a-z0-9]{3}-?[a-z0-9]{2}$/i

  def initialize(number)
    @number = number
    validate!
    @wagons = []
    @current_speed = 0
    @@trains[number] = self
    register_instance
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def map_wagons
    @wagons.each do |wagon|
      yield(wagon)
    end
  end

  def self.find(number)
    @@trains[number].nil? ? nil : @@trains[number]
  end
 
  def speed_up(num)
    @current_speed += num
  end

  def stop
    @current_speed = 0
  end

  def add_wagon(wagon)
    if is_idle? && self.type == wagon.type
      @wagons << wagon
      wagon.train = self
    else
      raise 'Поезд находится в движении или не совпадают типы поезд/вагон.'
    end
  end
    
  def remove_wagon(wagon)
    if is_idle?
      @wagons.delete(wagon)
      wagon.train = nil
    else
      raise 'Невозможно отцепить вагон, когда поезд движется'
    end
  end

  def set_route(route)
    @route = route
    @current_station = @route.stations.first
    @current_station.receive_train(self)
  end

  def previous_station
    if @current_station == @route.stations.first
      raise 'Нет станции, текущая станция - начальная'
    else
      @route.stations[@route.stations.index(@current_station) - 1]
    end
  end

  def next_station
    if @current_station == @route.stations.last
      raise 'Нет станции, текущая станция - конечная'
    else
      @route.stations[@route.stations.index(@current_station) + 1]
    end
  end

  def go_forward
    @current_station.depart_train(self)
    @current_station = next_station
    @current_station.receive_train(self)
  end

  def go_back
    @current_station.depart_train(self)
    @current_station = previous_station
    @current_station.receive_train(self)
  end

  protected

  def is_idle?
    if @current_speed == 0
      return true
    end
  end

  def validate!
    validate_train_number
    validate_train_presence
  end

  def validate_train_number
    raise 'Неверный формат номера поезда' if @number !~ NUMBER_FORMAT
  end

  def validate_train_presence
    raise 'Поезд с таким номером уже существует' unless @@trains[number].nil?
  end
end


