class WagonPass < Wagon
  def initialize(id)
    super
    @type = 'Пассажирский'
  end
end
