class TM::Employee
  attr_reader :id, :name
  def initialize( id, name )
    @id = id
    @name = name
  end


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


