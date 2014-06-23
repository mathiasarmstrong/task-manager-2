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
    command[place].is_number? ? command[place].to_i : id_verify(command[0])
  else
    -1
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
      emp_create( command[1..-1] )

    when 'show'
      eid = id_verify(command, 'project id')
      show( eid )

    when 'details'
      eid = id_verify(command, 'project id')
      details( eid )

    when 'history'
      eid = id_verify(command, 'project id')
      history( eid )

    when 'exit'
      exit

  else
    command[1..-1] = nil
    employee_verify(command)
  end
end

def task_verify( command )
  if command[1].nil?
    puts "which task command would you would like to use
      task create PID PRIORITY DESC - Add a new task to project PID
      task assign TID EID - Assign task to employee
      task mark TID - Mark task TID as complete"

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
       id_verify( command[1], 'Project id' )
       id_verify( command[2], 'task priority', 2 )





      task_create( command[1..-1] )

    when 'show'
      tid = id_verify(command, 'task')
      show( tid )

    when 'details'
      tid = id_verify(command, 'project id')
      details( tid )

    when 'history'
      tid = id_verify(command, 'project id')
      history( tid )

    when 'exit'
      exit

  else
    command[1..-1] = nil
    employee_verify(command)
end
end

def project_verify
end

#these methods are to test and convert user entries
    def change_to_string(command_array,position_of_first_element=1,position_of_last_element=-1)
      command_array[position_of_first_element..position_of_last_element].join(' ')
    end

    def change_to_number(command_array,position_of_number_to_convert=1)
      command_array[position_of_number_to_convert].to_i
    end

    def check_number(command_array,position_of_number_to_convert=1)
      command_array[position_of_number_to_convert].is_number?
    end

    def check_error(command_array,location=1)
      command_array[location].nil?
    end

    def check_projects(project_id)
      !TM::Project.library[project_id].nil?
    end

    def check_tasks(project_id,task_id)
      !TM::Project.library[project_id].tasks[task_id].nil?
    end

    def throw_error
      multi_word_command_selector('error',"error")
    end
#these methods tests the vaildity with regard to he projects

def multi_word_command_selector(command_array,project_id)
    case command_array[0]
      when "show"
        show(project_id) #shows remaining tasks for a project
      when "history"
        history(project_id)
      when "add" #adds a task to a project
        if (!check_error(command_array,2) && check_number(command_array,2))
            task_priority = change_to_number(command_array, 2)
            task_description = change_to_string(command_array, 3)
          if !check_error(command_array,3) && check_projects(project_id)
            add(project_id,task_priority,task_description)
          else
            throw_error
          end
        else
          multi_word_command_selector('error','error')
        end
      when "mark"
        if !check_error(command_array,2)&&check_number(command_array,2)
            task_id = change_to_number(command_array, 2)
          if check_projects(project_id) && check_tasks(project_id,task_id)
            mark(project_id, task_id)
          else
            throw_error
          end
        else
          throw_error
        end
      else
        puts "That was not a valid command."
        help
      end
    end
