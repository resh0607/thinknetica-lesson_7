class TrainCargo < Train
  def initialize(number)
    super
    @type = 'Грузовой'
  end
end
