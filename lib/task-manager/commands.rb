class Commands
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
    TM::Project.list
  end

  def project_create( name )
    TM::Project.create( name )
  end

  def project_show( pid )
    TM::Project.list_incomplete_tasks( pid )
  end

  def project_history( pid )
    TM::Project.list_complete_tasks( pid )
  end

  def project_employees ( pid )
    TM::Employees.list_employees_by_project( pid )
  end

  def project_recruit( pid, eid )
    TM::Project.add_employee( pid, eid )
  end

  def task_create( pid, priority, desc )
    TM::Task.create( desc, priority, pid )
  end

  def task_assign( tid, eid )
    TM::Task.assign( eid, tid )
  end

  def task_mark( tid )
    TM::Task.mark( tid )
  end

  def emp_list
    TM::Employee.list
  end

  def emp_create( name )
    TM::Employee.create( name )
  end

  def emp_show( eid )
    TM::Project.list_by_employee( eid )
  end

  def emp_details( eid )
    TM::Employee.remaining_tasks( eid )
  end

  def emp_history( eid )
    TM::Employee.finished_tasks( eid )
  end

end
