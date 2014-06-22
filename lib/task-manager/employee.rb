class TM::Employee
  attr_reader :id, :name
  def initialize( id, name )
    @id = id
    @name = name
  end

#---------------project methods----------------------

  # def create_new_project( name )
  #   TM.orm.add_project( name, @id )
  # end

  # def projects
  #   TM::Project.list_by_employee( @id )
  # end

  # def join_project( pid, id = @id )
  #   TM::Project.add_employee( pid, id ) unless TM::Project.select( pid ).nil?
  # end

#----------------task methods------------------------

  # def create_new_task( description, priority, pid )
  #   TM::Task.create( description, priority, pid, @id )
  # end

  # def assign_task( tid, eid = @id )
  #   TM::Task.assign( eid, tid )
  # end

  # def finished_tasks
  #   TM::Task.list_by_employee( @id ).select{ |task| task.completed == true }
  # end

  # def remaining_tasks
  #   TM::Task.list_by_employee( @id ).select{ |task| task.completed == false }
  # end

  # def complete_task( tid )
  #   TM::Task.mark( tid )
  # end

#---------------employee methods---------------------

  def self.create( name )
    TM.orm.add_employee( name )
  end

  def self.select_employee( eid )
    TM.orm.select_employee( eid )
  end

  def self.list
    TM.orm.list_employees
  end

  def self.list_employees_by_project( pid )
    TM.orm.list_employees_by_project( pid )
  end

  def self.finished_tasks ( eid )
    TM::Task.list_by_employee( eid ).select{ |task| task.completed == true }
  end

  def self.remaining_tasks( eid )
    TM::Task.list_by_employee( eid ).select{ |task| task.completed == false }
  end


end


