
# Create our module. This is so other files can start using it immediately
module TM
end

# Require all of our project files
require 'colorize'
require_relative 'task-manager/task.rb'
require_relative 'task-manager/project.rb'
require_relative 'task-manager/employee.rb'
require_relative 'task-manager/orm.rb'
require_relative 'task-manager/verify.rb'
require_relative 'task-manager/commands.rb'

