class Menu

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
  end

  def start
    loop do 
      puts "Что нужно сделать?:\n\t1.Создать станцию\n\t2.Создать поезд\n\t3.Создать маршрут\n\t4.Изменить маршрут\n\t5.Назначить маршрут поезду\n\t6.Добавить вагон к поеду\n\t7.Отцепить вагон\n\t8.Переместить поезд\n\t9.Посмотреть список станций и список поездов на станции\n\t0.Выйти"
      choice = gets.to_i
      case choice 
      when 1
        create_station
      when 2
        create_train
      when 3
        create_route
      when 4
        change_route
      when 5
        set_route_to_train
      when 6
        add_wagon_to_train
      when 7
        release_wagon
      when 8
        move_train
      when 9
        summary_info
      when 0
        break
      end
    end
  end

  private

  def all_stations_list
    @stations.each.with_index(1) do |station, index|
      puts "#{index}. #{station.name}"
    end
  end

  def all_routes_list
    @routes.each.with_index(1) do |route, index|
      puts "#{index}. #{route.name}"
    end
  end

  def all_trains_list
    @trains.each.with_index(1) do |train, index|
      puts "#{index}.Номер поезда - #{train.number}, тип - #{train.type}."
    end
  end

  def all_free_wagons_list
    @wagons.reject { |wagon| wagon.train == nil }.each.with_index(1) do |wagon, index|
      puts "#{index}.id - #{wagon.id}, тип - #{wagon.type}."
    end
  end

  def create_station
    attempts = 0
  begin
    puts 'Введите название станции:'
    station_name = gets.strip.capitalize
    @stations << Station.new(station_name)
  rescue RuntimeError => error
    puts "Ошибка: #{error.message}"
    attempts += 1
  retry if attempts < 3
  end
    puts "Создана новая станция - #{station_name}"
  end

  def create_train
    attempts = 0
  begin
    puts "Ведите тип поезда:\n\t1.Грузовой\n\t2.Пассажирский"
    type = gets.to_i
    puts 'Введите номер поезда: '
    number = gets.chomp.to_s
    type == 1 ? train = TrainCargo.new(number) : train = TrainPass.new(number)
  rescue RuntimeError => error
    puts "Ошибка: #{error.message}"
    attempts += 1
  retry if attempts < 3
  end
    @trains << train
    puts "Создан новый поезд. Номер - #{train.number}, тип - #{train.type}"
  end

  def create_route
    if @stations.size < 2
      puts 'Создайте станции!'
      (2 - @stations.size).times do
        create_station
      end    
    end
    attempts = 0
  begin
    puts 'Выберите начальную станцию:'
    all_stations_list
    index = gets.to_i
    initial_station = @stations[index - 1]
    puts 'Выберите конечную станцию:'
    all_stations_list
    index = gets.to_i
    final_station = @stations[index - 1]
    route = Route.new(initial_station, final_station)
  rescue RuntimeError => error
    puts "Ошибка: #{error.message}"
    attempts += 1
  retry if attempts < 3
  end
    @routes << route
    puts "Создан маршрут #{route.name}"
  end

  def change_route
    puts 'Выберите маршрут для изменения:'
    all_routes_list 
    index = gets.to_i
    route = @routes[index - 1]
    puts "1.Удалить станцию\n2.Добавить станцию"
    choice = gets.to_i
    case choice 
    when 1
      raise 'Вы не можете удалить станцию,т.к. в маршруте всего 2 станции' if route.stations.length == 2
      puts 'Какую станцию удалить?'
      route.stations_list
      index = gets.to_i
      station = route.stations[index - 1]
      route.remove_station(station)
    when 2
      puts 'Какую станцию добавить в маршрут?'
      all_stations_list
      index = gets.to_i
      station = @stations[index - 1]
      route.add_station(station)
    end
  end

  def set_route_to_train
    if @trains.empty? 
      puts 'Нет ни одного поезда, создайте поезд!'
      create_train
    end
    if @routes.empty?
      puts 'Нет ни одного маршрута, создайте маршрут!'
      create_route
    end
    puts 'Выберите поезд:'
    all_trains_list
    index = gets.to_i
    train = @trains[index - 1]
    puts 'Выберите маршрут:'
    all_routes_list
    index = gets.to_i
    route = @routes[index -1]
    train.set_route(route)
  end

  def create_new_wagon
    attempts = 0
  begin
    puts 'Введите id вагона: '
    id = gets.chomp.to_s
    puts "Введите тип вагона \n\t1.Грузовой \n\t2.Пассажирский" 
    type = gets.to_i
    type == 1 ? wagon = WagonCargo.new(id) : wagon = WagonPass.new(id)
  rescue RuntimeError => error
    puts "Ошибка: #{error.message}"
    attempts += 1
  retry if attempts < 3
    @wagons << wagon
    wagon
  end
  end

  def add_wagon_to_train
    puts 'Выберите поезд:'
    all_trains_list
    index = gets.to_i
    train = @trains[index - 1]
    puts "Создать вагон или выбрать из свободных?\n\t1.Создать новый\n\t2.Выбрать из наличия"
    index = gets.to_i
    case index
    when 1
      wagon = create_new_wagon
      train.add_wagon(wagon)
    when 2
      if @wagons.empty? 
        raise 'Нет ни одного вагона'
      else
        puts 'Выберите нужный вагон'
        all_free_wagons_list
        index = gets.to_i
        wagon = @wagons[index - 1]
        train.add_wagon(wagon)
      end 
    end
  end

  def release_wagon
    puts 'Выберите поезд'
    all_trains_list
    index = gets.to_i
    train = @trains[index - 1]
    puts 'Вагоны, прицепленные к данному поезду, выберите какой нужно отцепить'
    train.wagons.each.with_index(1) do |wagon, index|
      puts "#{index}.id - #{wagon.id}, тип - #{wagon.type}."
    end
    index = gets.to_i
    wagon = train.wagons[index - 1]
    train.remove_wagon(wagon)
  end

  def move_train
    puts 'Выберите поезд:'
    all_trains_list
    index = gets.to_i
    train = @trains[index - 1]
    puts "Выберите направление:\n\t1.Вперед\n\t2.Назад"
    direction = gets.to_i
    if direction == 1
      train.go_forward
    elsif direction == 2
      train.go_back
    else 
      raise 'Нет такого направления'
    end
  end
  
  def summary_info
    puts "Список всех станций.\nВыберите станцию для просмотра дополнительной информации:"
    all_stations_list
    index = gets.to_i
    station = @stations[index - 1]
    if station.trains.empty?
      raise 'На этой станции нет поездов'
    else
      station.trains.each do |train|
        puts "Номер моезда - #{train.number}, тип - #{train.type}"
      end
    end
  end
end





















