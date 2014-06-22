require "pry-byebug"
class TM::Task
  attr_reader :id, :description, :priority, :project_id, :employee_id, :creation_date, :completed

  def initialize(id, description, priority, project_id, employee_id, creation_date, completed)
    @id = id
    @description = description
    @priority = priority
    @project_id = project_id
    @employee_id = employee_id
    @creation_date = creation_date
    @completed = completed
  end

  def self.select( tid )
    TM.orm.select_task( tid )
  end

  def self.list_by_project( pid )
    tasks = TM.orm.list_tasks
    tasks = tasks.select{|task| task.project_id == pid}
  end

  def self.list_by_employee( eid )
    tasks = TM.orm.list_tasks
    tasks = tasks.select{|task| task.employee_id == eid}
  end

  def self.create( description, priority, pid, eid = nil )
    TM.orm.add_task( description, priority, pid, eid )
  end

  def self.assign( eid, tid )
    TM.orm.assign_task( eid, tid )
  end

  def self.mark( tid )
    TM.orm.mark_task_complete( tid )
  end

end
