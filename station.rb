class Station
  attr_reader :name, :trains
  include InstanceCounter
  @@stations = []

  NAME_FORMAT = /^[а-яa-z]+\s?[а-яa-z]*$/i

  def initialize(name)
    @name = name 
    validate!
    @trains = []
    @@stations << self
    register_instance
  end

  def valid?
    validate!
    true
  resсue
    false
  end

  def self.all
    @@stations
  end

  def map_trains
    @trains.each do |train|
      yield(train)
    end
  end

  def show_trains_with_type(type)
    @trains.select { |train| train.type == type}
  end

  def receive_train(train)
    @trains << train
  end
  
  def depart_train(train)
    @trains.delete(train)
  end

  protected

  def validate!
    validate_station_name
    validate_station_presence
  end

  def validate_station_name
    raise 'Неверный формат названия станции' if @name !~ NAME_FORMAT
  end

  def validate_station_presence
    raise 'Станция с таким названием уже существует' if @@stations.map { |station| station.name }.include?(@name)
  end
end
