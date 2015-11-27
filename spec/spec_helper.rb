require 'rspec'
require './todos.rb'
RSpec.configure do|config|
	#use color in STDOUT
    config.color= true
    #not only colors in STDOUT but also in pagers and files
    config.tty = true
    #use specified informer
    config.formatter = :documentation
end