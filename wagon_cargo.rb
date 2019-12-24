class WagonCargo < Wagon
  def initialize(id)
    super
    @type = 'Грузовой'
  end
end
