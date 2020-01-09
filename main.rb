require_relative 'menu'
require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'train'
require_relative 'train_cargo'
require_relative 'train_pass'
require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'wagon_cargo'
require_relative 'wagon_pass'

controller = Menu.new
controller.start

