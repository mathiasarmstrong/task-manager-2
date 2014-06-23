

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
    emp history EID - Show completed tasks for employee with id=EID"
end

def project_list
  TM::Project.list.each do|project|
    puts "      -----------------------------
          project name: #{ project.name }
          project id:   #{ project.id }
          ------------------------------"
  end
end

def project_create( name )
  unless name.nil?
    project = TM::Project.create( name )
    puts "You have created a project
      name:   #{ project.name }
      id:     #{ project.id }

      -------------------------------"
  end
end

def project_show( pid )
  unless pid.nil?
    TM::Project.incomplete( pid ).each do|task|
      puts "      -----------------------------
            task priority:    #{ task.priority }
            task description: #{ task.description }
            ------------------------------"
    end
  end
end

def project_history( pid )
  unless pid.nil?
    TM::Project.complete( pid ).each do|task|
      puts "      -----------------------------
            task date:    #{ task.creation_date }
            task description: #{ task.description }
            ------------------------------"
    end
  end
end

def project_employees ( pid )
  unless pid.nil?

    TM::Employees.list_employees_by_project( pid ).each do|employee|
      puts "      -----------------------------
            employee id:    #{ employee.name }
            employee name: #{ employee.name }
            ------------------------------"
    end
  end
end


def project_recruit( pid, eid = nil )
  unless pid.nil?
    TM::Project.add_employee( pid, eid )
    puts "employee with id: #{ eid } has been added to project with id: #{ pid }"
  end
end

def task_create( pid, priority = nil, desc = nil )
  unless pid.nil?
    task = TM::Task.create( desc, priority, pid )
    puts "You have created a task
      priority:   #{ task.priority }
      id:         #{ task.id }
      description:#{ task.description }
      -------------------------------"
  end
end

def task_assign( tid, eid = nil )
  unless tid.nil?
    TM::Task.assign( eid, tid )
    puts "employee with id: #{ eid } has been assigned task with id: #{ tid }"
  end
end

def task_mark( tid )
  unless tid.nil?
    TM::Task.mark( tid )
    puts "task with id #{ tid } has been marked as complete"
  end
end

def emp_list
  TM::Employee.list.each do|employee|
    puts "      -----------------------------
          employee id:    #{ employee.name }
          employee name: #{ employee.name }
          ------------------------------"
  end
end

def emp_create( name )
  unless name.nil?
    TM::Employee.create( name )

     puts "You have created an employee
      name:   #{ employee.name }
      id:     #{ employee.id }
      -------------------------------"
  end
end

def emp_show( eid )
  unless eid.nil?
    puts "Employee with id #{ eid } has access to the following projects: "
    TM::Project.list_by_employee( eid ).each do|project|
      puts "      -----------------------------
            project name: #{ project.name }
            project id:   #{ project.id }
            ------------------------------"
    end
  end
end

def emp_details( eid )
  unless eid.nil?

    puts "The uncomplete tasks for employee with id #{ eid }:"
    TM::Employee.remaining_tasks( eid ).each do|task|
      puts "      -----------------------------
            task priority:    #{ task.priority }
            task description: #{ task.description }
            ------------------------------"
    end
  end
end

def emp_history( eid )
  unless eid.nil?

    puts "the completed tasks for employee with id #{ eid }"
    TM::Employee.finished_tasks( eid ).each do|task|
      puts "      -----------------------------
            task date:    #{ task.creation_date }
            task description: #{ task.description }
            ------------------------------"
    end
  end
end
