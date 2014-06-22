#----------------requirements--------------------------
  require "pry-byebug"
  require_relative "./lib/task-manager.rb"

  class String
    def is_number?
      true if Float(self) rescue false
    end
  end


class TerminalClient

#---------terminal client initialization----------------
  def initialize
    if employee.list.length == 0
      @emp = TM.orm.add_employee( 'default employee' )
    else
      @emp = TM::Employee.list_employees.length == 0
    end
    puts "Welcome to Project Manager Pro®."
    puts "What can I do for you today?"
    help
  end


# #these methods are to test and convert user entries
  #   def change_to_string(command_array,position_of_first_element=1,position_of_last_element=-1)
  #     command_array[position_of_first_element..position_of_last_element].join(' ')
  #   end

  #   def change_to_number(command_array,position_of_number_to_convert=1)
  #     command_array[position_of_number_to_convert].to_i
  #   end

  #   def check_number(command_array,position_of_number_to_convert=1)
  #     command_array[position_of_number_to_convert].is_number?
  #   end

  #   def check_error(command_array,location=1)
  #     command_array[location].nil?
  #   end

  #   def check_projects(project_id)
  #     !TM::Project.library[project_id].nil?
  #   end

  #   def check_tasks(project_id,task_id)
  #     !TM::Project.library[project_id].tasks[task_id].nil?
  #   end

  #   def throw_error
  #     multi_word_command_selector('error',"error")
  #   end
# #these methods tests the vaildity with regard to he projects

#these methods take the user command and activate the correct command method
  def command_selector(user_input)
    command = user_input.split{/' '/}

    case command[0]

    when "help"
      help

    when "project"
      command = verify( command )
      project_commands( command )

    when "emp"
      command = verify( command )
      employee_commands( command )

    when 'task'
      command = verify( command )
      task_commands( command )

    when "exit"
      puts "Goodbye!"
    else

    end
  end


# employee commands

  def employee_commands(command)
    case command[1]
    when 'list'
      TM.orm.list_employees
    when 'create'
      TM.orm.add_employee( name )
    when 'show'
      emp = TM::Employee.select_employee( eid )
      tasks = emp.remaining_tasks
      tasks.each do |task|
        puts task.project_id
      end
    when 'details'
    details ( eid )
    history ( eid )
  end

#project commands
  def project_commands
    list
    create ( name )
    show ( pid )
    history ( pid )
    employees ( pid )
    recruit ( pid, eid )
  end

#task commands
  def task_commands
    create ( pid, priority, desc )
    assign ( tid, eid )
    mark ( tid )


# def multi_word_command_selector(command_array,project_id)
  #   case command_array[0]
  #     when "show"
  #       show(project_id) #shows remaining tasks for a project
  #     when "history"
  #       history(project_id)
  #     when "add" #adds a task to a project
  #       if (!check_error(command_array,2) && check_number(command_array,2))
  #           task_priority = change_to_number(command_array, 2)
  #           task_description = change_to_string(command_array, 3)
  #         if !check_error(command_array,3) && check_projects(project_id)
  #           add(project_id,task_priority,task_description)
  #         else
  #           throw_error
  #         end
  #       else
  #         multi_word_command_selector('error','error')
  #       end
  #     when "mark"
  #       if !check_error(command_array,2)&&check_number(command_array,2)
  #           task_id = change_to_number(command_array, 2)
  #         if check_projects(project_id) && check_tasks(project_id,task_id)
  #           mark(project_id, task_id)
  #         else
  #           throw_error
  #         end
  #       else
  #         throw_error
  #       end
  #     else
  #       puts "That was not a valid command."
  #       help
  #     end
  #   end


# these methods are the command methods
  def help
    puts "Available Commands:
      help - Show these commands again
      project list - List all projects
      project create NAME - Create a new project
      project show PID - Show remaining tasks for project PID
      project history PID - Show completed tasks for project PID
      project employees PID - Show employees participating in this project
      project recruit PID EID - Adds employee EID to participate in project PID
      task create PID PRIORITY DESC - Add a new task to project PID
      task assign TID EID - Assign task to employee
      task mark TID - Mark task TID as complete
      emp list - List all employees
      emp create NAME - Create a new employee
      emp show EID - Show employee EID and all participating projects
      emp details EID - Show all remaining tasks assigned to employee EID,
                        along with the project name next to each task
      emp history EID - Show completed tasks for employee with id=EID
"






# Available Commands:
  #       help - Show these commands again
  #       list - List all projects
  #       create NAME - Create a new project with name=NAME
  #       show PID - Show remaining tasks for project with id=PID
  #       history PID - Show completed tasks for project with id=PID
  #       add PID PRIORITY DESC - Add a new task to project with id=PID
#       mark PID TID - Mark task with PID TID (project_id task_id) as complete


# def list
  #   puts "Showing all projects"
  #   puts "PID           Name"
  #   TM::Project.library.each do |existing_project|
  #     puts "#{existing_project.id}              #{existing_project.name}"
  #   end
  #   command_selector(gets.chomp)
  # end

  # def create project_name
  #   TM::Project.new(project_name)
  #   puts "Project #{project_name} has been created.
  #   #{TM::Project.library[-1].id} is the Project ID (PID)"
  #   command_selector(gets.chomp)
  # end

  # def show project_id
  #   puts "Showing tasks for Project #{TM::Project.library[project_id].name}"
  #   puts "Priority   TID  Description"
  #   TM::Project.library[project_id].list_incomplete_tasks.each do |task|
  #     puts "#{task.priority}          #{task.id}      #{task.description}"
  #   end
  #   command_selector(gets.chomp)
  # end

  # def history project_id
  #   puts "Showing completed tasks for Project #{TM::Project.library[project_id].name}"
  #   puts "Date created                        ID  Description"
  #   TM::Project.library[project_id].list_complete_tasks.each do |task|
  #     puts "#{task.creation_date.asctime}            #{task.id}   #{task.description}"
  #   end
  #   command_selector(gets.chomp)
  # end

  # def add(project_id, task_priority, task_description)
  #   TM::Project.library[project_id].add_task(task_description,task_priority)
  #   puts " A new task has been created for project #{TM::Project.library[project_id].name}.
  #   #{TM::Project.library[project_id].tasks[-1].id} is the Task ID (TID)
  #   The description is :
  #   #{task_description}"
  #   command_selector(gets.chomp)
  # end

  # def mark(project_id,task_id)
  #   TM::Project.library[project_id].complete_task(task_id)
  #   puts "Congratulations you have completed a task in #{TM::Project.library[project_id].name}
  #   the task id number was #{task_id} and the description was:
  #   #{TM::Project.library[project_id].tasks[task_id].description}"
  #   command_selector(gets.chomp)
  # end

end

TerminalClient.new

