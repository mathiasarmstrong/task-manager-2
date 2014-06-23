  class String
    def is_number?
      true if Float( self ) rescue false
    end
  end


def separate(user_input)
  user_input.split{/' '/}
end

def id_verify( command, type, place=1 )

  if command[place].nil?
    puts "please enter the #{type} number or exit"
    command[place] = gets.chomp
  end

  if command[place]!='exit'
    if command[place].is_number?
      command[place] = command[place].to_i
    else
      command = id_verify(command, type, place)
    end
    return command
  else
    []
  end
end

def employee_verify( command )
  if command[1].nil?
    puts "which employee command would you would like to use
      list - List all employees
      create NAME - Create a new employee
      show EID - Show employee EID and all participating projects
      details EID - Show all remaining tasks assigned to employee EID,
                        along with the project name next to each task
      history EID - Show completed tasks for employee with id=EID"
    command = separate(gets.chomp)
  end

  command.shift if command[0]=='project'

  case command[0]
    when list
      emp_list

    when 'create'
      if command[1].nil?
        puts "please enter the employee name"
        command[1] = gets.chomp
      end
      emp_create( command[1..-1].join(' ') )

    when 'show'
      command = id_verify(command, 'project id')
      emp_show( command[1] )

    when 'details'
      command = id_verify(command, 'project id')
      emp_details( command[1] )

    when 'history'
      command = id_verify(command, 'project id')
      emp_history( command[1] )

    when 'exit'
      emp_show(nil)

  else
    command[1..-1] = nil
    employee_verify(command)
  end
end

def task_verify( command )

  if command[1].nil?
    puts "which task command would you would like to use
      create PID PRIORITY DESC - Add a new task to project PID
      assign TID EID - Assign task to employee
      mark TID - Mark task TID as complete"

    command = separate(gets.chomp)
  end

  command.shift if command[0]=='task'

  case command[0]

    when 'create'
      if command[1].nil? || command[2].nil? || command[3].nil?
        puts "please enter the Project id, priority and the description"
        command[1..-1] = gets.chomp
        command = command[0]+command[1].split{ /' '/ }
      end
      command = id_verify( command, 'Project id' )
      command = id_verify( command, 'Task priority', 2 )

      task_create( command[1], command[2], command[3..-1] )

    when 'assign'
      if command[1].nil? || command[2].nil?
        puts "please enter the Task id and the Employee id"
        command[1..-1] = gets.chomp
        command = command[0]+command[1].split{ /' '/ }
      end
      command = id_verify( command, 'Task id' )
      command = id_verify( command, 'Employee id', 2 )

      task_assign( command[1], command[2])

    when 'mark'
      command = id_verify(command, 'task id')
      task_mark( command[1] )

    when 'exit'
      task_assign(nil)

  else
    command[1..-1] = nil
    task_verify(command)
  end
end

def project_verify( command )

  if command[1].nil?
    puts "which project command would you would like to use
      list - List all projects
      create NAME - Create a new project
      show PID - Show remaining tasks for project PID
      history PID - Show completed tasks for project PID
      employees PID - Show employees participating in this project
      recruit PID EID - Adds employee EID to participate in project PID"

        command = separate(gets.chomp)
  end

  command.shift if command[0]=='project'

  case command[0]
  when list
      project_list

  when 'create'
    if command[1].nil?
      puts "please enter the project name"
      command[1] = gets.chomp
    end
    project_create( command[1..-1].join(' ') )

  when 'show'
    command = id_verify(command, 'project id')
    project_show( command[1] )

  when 'history'
    command = id_verify(command, 'project id')
    project_history( command[1] )

  when 'employees'
    command = id_verify(command, 'project id')
    project_employees( command[1] )

  when 'recruit'
    if command[1].nil? || command[2].nil?
        puts "please enter the Project id and the Employee id"
        command[1..-1] = gets.chomp
        command = command[0]+command[1].split{ /' '/ }
      end
      command = id_verify( command, 'Project id' )
      command = id_verify( command, 'Employee id', 2 )

      project_recruit( command[1], command[2] )

  when 'exit'
      project_show(nil)

  else

    command[1..-1] = nil
    project_verify(command)
  end
end

