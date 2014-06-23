#----------------requirements--------------------------
  require "pry-byebug"
  require_relative "./lib/task-manager.rb"



class TerminalClient

  def initialize
    puts "Welcome to Project Manager Pro®."
    puts "What can I do for you today?"
    help
  end



  def command_selector(user_input)

    command = user_input.split{/' '/}

    case command[0]

    when "help"
      help

    when "project"
       verify_project( command )

    when "emp"
      command = verify_emp( command )

    when 'task'
      command = verify_task( command )

    when "exit"
      puts "Goodbye!"
      break

    else
      puts 'Please enter a valid command'
      help
    end
    command_selector(gets.chomp)
  end






end

TerminalClient.new

