require 'spec_helper'

describe 'Employee' do

#---------intialize test database-------------------

  before( :all ) do
    TM.orm.instance_variable_set( :@db_adaptor, PG.connect( host: 'localhost', dbname: 'task-manager-test' ) )
    TM.orm.create_tables
  end

  before( :each ) do
    TM.orm.reset_tables
  end

  after( :all ) do
    TM.orm.drop_tables
  end

#------------Employee methods-----------------------

  context 'creating a new TM::Employee' do

    it 'creates an instance of the TM::Employee class with a name and id number' do
      test = TM::Employee.new( 1, 'tom' )
      expect( test.name ).to eq( 'tom' )
      expect( test.id ).to be_a( Fixnum )
    end
  end

#-------------project methods-----------------------

  describe '#create_new_project' do
    let( :test ){ TM::Employee.create( 'tom' ) }

    context 'creates a new project using a name' do

      it 'gets the name and an id' do
        project = TM::Project.create( 'first' )
        expect(project.name).to eq( 'first' )
        expect(project.id).to be_a( Fixnum )
      end

      it 'adds the project to your projects' do
        expect( TM::Project.list_by_employee( test.id ).length ).to eq( 0 )
        project = TM::Project.create( 'first' )
        TM::Project.add_employee( project.id, test.id )
        expect( TM::Project.list_by_employee( test.id ).length ).to eq( 1 )

      end
    end
  end


  describe '#join_project' do

    let( :test ){ TM::Employee.create( 'tom' ) }

    context 'when adding a person to a project' do

      it 'confirms that the project exists' do
        TM::Project.add_employee( 100, test.id )
        expect( TM::Project.list_by_employee( test.id ).length ).to eq( 0 )
      end

      it 'adds the TM::employee to the project' do
        emp2 = TM::Employee.create( 'jon' )
        emp3 = TM::Employee.create( 'andrew' )

        expect( TM::Project.list_by_employee( emp3.id ).length  ).to eq( 0 )

        project = TM::Project.create('jons project' )
        TM::Project.add_employee( project.id, emp2.id )
        TM::Project.add_employee( project.id, emp3.id )

        expect( TM::Project.list_by_employee( test.id ).length  ).to eq( 0 )
        expect( TM::Project.list_by_employee( emp2.id ).length  ).to eq( 1 )
        expect( TM::Project.list_by_employee( emp3.id ).length  ).to eq( 1 )
      end
    end
  end

#--------------task methods-------------------------

  describe '#create_new_task' do

    let( :test ){ TM::Employee.create( 'tom' ) }

    context 'when creating a new task with a description and project id and priority number' do
      it 'gets an id number' do
        project = TM::Project.create('jons project' )
        task = TM::Task.create( 'this is a new task', 0, project.id, test.id )
        expect( task.id ).to be_a( Fixnum )
        expect( task.description ).to eq( 'this is a new task' )
        expect( task.project_id ).to eq( project.id )
      end

      it 'is added to your tasks' do
        expect( TM::Employee.remaining_tasks( test.id ).length ).to eq( 0 )
        project = TM::Project.create( 'jons project' )
        task = TM::Task.create( 'this is a new task', 0, project.id, test.id )
        expect( TM::Employee.remaining_tasks( test.id ).length ).to eq( 1 )
      end
    end
  end

  describe '#assign_task' do
    let( :test ){ TM::Employee.create( 'tom' ) }

    context 'when assiging or reassigning a task' do

      it 'confirms the task exists' do
        emp2 = TM::Employee.create( 'john')
        TM::Task.assign( emp2.id, 10 )
        expect( TM::Employee.remaining_tasks( emp2 ).length ).to eq( 0 )
      end
    end
  end

end
