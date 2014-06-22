
class TM::Project
  attr_reader :name, :id


  def initialize( name, id )
    @name = name
    @id = id
  end

#------task methods----------------

  #   tasks = tasks.sort do |task1,task2|
  #     comp = ( task1.priority <=> task2.priority )
  #     comp == 0 ? ( task1.creation_date <=> task2.creation_date ) : comp
  #   end
  # end

#--------project methods----------

  def self.create( name )
    TM.orm.add_project( name )
  end

  def self.list
    TM.orm.list_projects
  end

  def self.list_complete_tasks( pid )
    all_tasks = TM::Task.list_by_project( pid )
    tasks = all_tasks.select{ |task| task.completed == true }.sort_by{|task| task.creation_date}
  end

  def self.list_incomplete_tasks( pid )
    all_tasks = TM::Task.list_by_project( pid )
    tasks = all_tasks.select{ |task| task.completed == false }
    tasks.sort do |task1,task2|
      comp = task1.priority<=>task2.priority
      if comp ==0 ? task1.creation_date <=> task2.creation_date : comp
    end
  end

  def self.select( pid )
    TM.orm.select_project( pid )
  end

  def self.add_employee ( pid, eid )
    TM.orm.add_employee_to_project( pid, eid ) unless select( pid ).nil?
  end

  def self.list_by_employee( eid )
    TM.orm.list_projects_by_employee( eid )
  end
end

