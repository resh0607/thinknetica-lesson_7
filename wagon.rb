class Wagon
  attr_reader :id, :type
  attr_accessor :train
  include Manufacturer
  @@wagons = {}

  ID_FORMAT = /^0[a-z]{1}\d{3}$/i

  def initialize(id)
    @id = id
    validate!
    @@wagons[id] = self
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  protected

  def validate!
    validate_wagon_id
    validate_wagon_presence
  end

  def validate_wagon_id
    raise 'Неверный формат ID вагона' if @id !~ ID_FORMAT
  end

  def validate_wagon_presence
    raise 'Вагон с таким ID уже существует' unless @@wagons[id].nil?
  end
end
