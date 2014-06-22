require 'spec_helper'

describe 'Task' do

#-------intialize test database and variables--------
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

  it "exists" do
    expect( TM::Task ).to be_a( Class )
  end

    let( :tom ){ TM.orm.add_employee( 'tom' ) }
    let( :test ){ TM.orm.add_project( 'first', tom.id ) }
    let( :task ){ tom.create_new_task("new task", 1, test.id ) }

#--------------task methods--------------------------

  describe '#initialize' do

    context 'new task is created with a project id a description and a priority number' do

      it 'has the project id' do
        expect( task.project_id ).to be_a(Integer)
      end

      it 'has a description' do
        expect(task.description).to eq("new task")
      end

      it 'has a priority number' do
        expect(task.priority).to eq(1)
      end

      it 'has a default status of uncompleted' do
        expect(task.completed).to eq(false)
      end

      it 'has an id number' do
        expect(task.id).to be_a(Integer)
      end

      it 'has a creation date' do
        expect(Time.parse(task.creation_date)).to be_a(Time)
        #stub time to make sure its st properly
      end
    end
  end
end

