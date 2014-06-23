require 'spec_helper'

describe 'ORM' do

#----------------database setup---------------------

  before( :all ) do
    #this connects us to our test datbase instead of our persistant database
    TM.orm.instance_variable_set( :@db_adaptor, PG.connect( host: 'localhost', dbname: 'task-manager-test' ) )
    TM.orm.create_tables
  end

  before( :each ) do
    TM.orm.reset_tables
  end

  after( :all ) do
    TM.orm.drop_tables
  end

#--------------intialization tests------------------

 it 'is an orm' do
    expect( TM.orm ).to be_a( TM::ORM )
  end

 it 'created with a db adaptor' do
    expect( TM.orm.db_adaptor ).not_to be_nil
  end

#----------------employee methods-------------------

  describe '#add_employee' do

   it 'creates a new employee with name and returns a employee instance' do
      expect( TM.orm.add_employee( 'Tom' ) ).to be_a( TM::Employee )
    end
  end


  describe '#list_employees' do

    it 'lists the employees in the database' do
      TM.orm.add_employee( 'jon' )
      TM.orm.add_employee( 'britney' )
      employees = TM.orm.list_employees.map{ |employee| employee.name }
      expect( employees ).to include( 'jon', 'britney' )
    end
  end


  describe '#remove_employee' do

    it 'removes the employee in the database' do
      jon = TM.orm.add_employee( 'jon' )
      TM.orm.remove_employee( jon.id )
      employees = TM.orm.list_employees.map{ |employee| employee.name }
      expect( employees ).not_to include( 'jon' )
    end
  end

#----------------project methods--------------------

  let( :jon ){ TM.orm.add_employee( 'jon' ) }


  describe '#add_project' do

    it 'adds the project to the database and returns a Project instance' do
      expect( TM.orm.add_project( 'coffee', jon.id ) ).to be_a( TM::Project )
    end
  end

  describe '#list_projects' do

    it 'lists the projects in the database' do
      coffee = TM.orm.add_project( 'coffee', jon.id )
      tea = TM.orm.add_project( 'tea', jon.id )
      names = TM.orm.list_projects.map{ |project| project.name }
      ids = TM.orm.list_projects.map{ |project| project.id }
      expect( names ).to include( 'tea', 'coffee' )
      expect( ids ).to include( tea.id, coffee.id )
    end
  end

  describe '#remove_project' do

    it 'removes the project in the database' do
      tea = TM.orm.add_project( 'tea', jon.id )
      TM.orm.add_project( 'coffee', jon.id )
      TM.orm.remove_project( tea.id )
      expect( TM.orm.list_projects.map{ |project| project.name } ).not_to include( 'tea' )
    end
  end

#------------------task methods---------------------

  let( :tea ){ TM.orm.add_project( 'tea', jon.id ) }

  describe '#add_task' do

    it 'adds the task to the database and returns a task instance' do
      expect( TM.orm.add_task( 'get coffee', 1, tea.id, jon.id ) ).to be_a( TM::Task )
    end
  end

  describe '#list_tasks' do

    it 'lists the tasks in the database by project id or by employee id' do
      TM.orm.add_task( 'get coffee', 1, tea.id, jon.id )
      TM.orm.add_task( 'get tea', 0, tea.id, jon.id )
      expect( TM.orm.list_tasks.map{ |task| task.priority } ).to include( 1, 0 )
    end
  end



  describe '#assign_task' do

    it 'assigns a task to an employee' do
      britney = TM.orm.add_employee( 'britney' )
      test = TM.orm.add_task( 'get coffee', 1, tea.id, jon.id )
      expect( test.employee_id ).to eq( jon.id )

      TM.orm.assign_task( britney.id, test.id )
      expect( TM::Task.select(test.id).employee_id ).to eq( britney.id )
    end
  end


  describe '#remove_task' do

    it 'removes the task in the database' do
      test = TM.orm.add_task( 'get tea', 0, tea.id, jon.id )
      expect( TM.orm.list_tasks.length ).to eq( 1 )
      TM.orm.remove_task( test.id )
      expect( TM.orm.list_tasks.map{ |task| task.id } ).not_to include( test.id )
    end
  end
end

