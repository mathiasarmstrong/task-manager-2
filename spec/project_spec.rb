require 'spec_helper'

describe 'Project' do

#-------initialize test database and variables--------
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

  let( :tom ){ TM::Employee.create( 'tom' ) }
  let( :test ){ TM::Project.create( 'first' ) }

#----------------Project methods----------------------

  it "exists" do
    expect( TM::Project ).to be_a(Class )
  end


  context 'project is started with a name' do

    it 'has a name' do
      expect( test.name ).to eq('first')
    end
  end


  context 'starting a new project' do

    it 'has an id number' do
      expect( test.id ).to be_a(Fixnum)
    end
  end


  describe '#list_tasks' do

    context 'when called with no tasks' do

      it 'returns an empty array' do
        expect( TM::Project.list_complete_tasks( test.id ).length ).to eq( 0 )
      end
    end


    context 'when called with no completed tasks' do

      it 'returns an empty array' do
        TM::Task.create( "new task", 1, test.id , tom.id )
        expect( TM::Project.list_complete_tasks( test.id ).length ).to eq( 0 )
      end
    end


    context 'when called with 1 completed tasks' do

      it 'returns an array containing that task' do
        task = TM::Task.create( "new task", 1, test.id , tom.id )
        TM::Task.mark( task.id )
        expect( TM::Project.list_complete_tasks( test.id ).length ).to eq( 1 )
      end
    end


    context 'when called with several completed tasks and several incompleted tasks' do

      it 'returns an array with the completed tasks' do
        task = TM::Task.create( "new task", 1, test.id , tom.id )
        task1 = TM::Task.create( "new task", 1, test.id , tom.id )
        task2 = TM::Task.create( "new task", 300, test.id , tom.id )
        task3 = TM::Task.create( "new task", 1, test.id , tom.id )
        task4 = TM::Task.create( "new task", 3, test.id , tom.id )
        TM::Task.mark( task.id )
        TM::Task.mark( task2.id )
        expect( TM::Project.list_complete_tasks( test.id ).length ).to eq( 2 )
      end

      it 'also returns tasks in order of creation date' do
        task = TM::Task.create( "new task", 1, test.id , tom.id )
        Time.stub(:now).and_return(Time.new(2013,5,1,8,30))
        task1 = TM::Task.create( "new task", 1, test.id , tom.id )
        task2 = TM::Task.create( "new task", 300, test.id , tom.id )
        task3 = TM::Task.create( "new task", 1, test.id , tom.id )
        task4 = TM::Task.create( "new task", 3, test.id , tom.id )
        TM::Task.mark( task.id )
        TM::Task.mark( task2.id )
        tasks = TM::Project.list_complete_tasks( test.id )
        expect( tasks[0].id ).to eq( task2.id )
        confirm_date_order = tasks[0].creation_date < tasks[1].creation_date
        expect( confirm_date_order ) .to be_true
      end
    end
  end


  describe '#list_incomplete_tasks' do

    context 'when called with no tasks' do

      it 'returns an empty array' do
        expect(TM::Project.list_incomplete_tasks( test.id ) ).to eq([])
      end
    end


    context 'when called with 1 incompleted tasks' do

      it 'returns an array containing that task' do
        task1 = TM::Task.create( "new task2", 1, test.id, tom.id )
        expect(TM::Project.list_incomplete_tasks( test.id ).length).to eq(1)
      end
    end


    context 'when called with 1 completed tasks' do

      it 'returns an empty array' do
        task1 = TM::Task.create( "new task2", 1, test.id, tom.id )
        TM::Task.mark( task1.id )
        expect( TM::Project.list_incomplete_tasks( test.id ) ).to eq( [] )
      end
    end


    context 'when called with several completed tasks and several uncompleted tasks' do

      it 'returns an array with the incompleted tasks' do
        task = TM::Task.create( "new task", 1, test.id , tom.id )
        Time.stub(:now).and_return(Time.new(2013,5,1,8,30))
        task1 = TM::Task.create( "new task", 1, test.id , tom.id )
        task2 = TM::Task.create( "new task", 300, test.id , tom.id )
        task3 = TM::Task.create( "new task", 1, test.id , tom.id )
        task4 = TM::Task.create( "new task", 3, test.id , tom.id )
        TM::Task.mark( task.id )
        TM::Task.mark( task2.id )
        tasks = TM::Project.list_incomplete_tasks( test.id )
        expect( tasks.length ).to eq( 3 )
      end

      it 'in order of priority' do
        task = TM::Task.create( "new task", 1, test.id , tom.id )
        Time.stub(:now).and_return(Time.new(2013,5,1,8,30))
        task1 = TM::Task.create( "new task", 2, test.id , tom.id )
        task2 = TM::Task.create( "new task", 300, test.id , tom.id )
        task3 = TM::Task.create( "new task", 1, test.id , tom.id )
        task4 = TM::Task.create( "new task", 3, test.id , tom.id )
        TM::Task.mark( task.id )
        TM::Task.mark( task2.id )
        tasks = TM::Project.list_incomplete_tasks( test.id )
        prior = tasks[0].priority < tasks[1].priority
        expect( prior ).to be_true
        prior = tasks[-1].priority < tasks[0].priority
        expect( prior ).to be_false
        prior = tasks[-1].priority < tasks[0].priority
        expect( prior ).to be_false
      end

      xit 'and if they have the same priority then the older of the two gets gets priority' do
        task = tom.create_new_task( "new task", 1, test.id )
        task1 = tom.create_new_task( "new task2", 1, test.id )
        task2 = tom.create_new_task( "new task3", 300, test.id )
        Time.stub( :now ).and_return( Time.new( 2013,5,1,8,30 ) )
        task3 = tom.create_new_task( "new task4", 1, test.id )
        task4 = tom.create_new_task( "new task5", 3, test.id )
        tom.complete_task( task.id )
        tom.complete_task( task2.id )
        tasks = test.list_incomplete_tasks
        prior = tasks[0].creation_date < tasks[1].creation_date
        expect( prior ).to be_true
      end
    end
  end
end
