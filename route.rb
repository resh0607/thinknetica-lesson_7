class Route
  attr_reader :stations, :name
  include InstanceCounter
  @@routes = []

  def initialize(initial_station, final_station)
    @stations = [initial_station, final_station]
    validate!
    @@routes << self 
    register_instance 
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def name 
    @name = stations.first.name + '-' + stations.last.name 
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def stations_list
    stations.each.with_index(1) do |station, index|
      puts "#{index}.#{station.name}"
    end
  end

  def remove_station(station)
    @stations.delete(station)
  end

  protected

  def validate!
    validate_route_presence
  end

  def validate_route_presence
    raise 'Такой маршрут уже существует' if @@routes.map { |route| route.stations }.include?(@stations)
  end
end




