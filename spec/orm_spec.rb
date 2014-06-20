require spec_helper

describe 'ORM' do
  before(:all) do
    #this connects us to our test datbase instead of our persistant database
    TM.orm.instance_variable_set(:@db_adaptor, PG.connect(host: 'localhost', dbname: 'task-manager-test') )
    #this is to create the tables for us to use for testing, new and empty
    TM.orm.create_tables
  end

#this clears the tables we are using before each and every test
  before(:each) do
    TM.orm.reset_tables
  end

  #this drops all the tables when we are finished with testing so as not to create clutter
  after(:all) do
    TM.orm.drop_tables
  end

#here is were our ORM testing really begins testing out all of the methods in our ORM class
  #here TM.orm returns a singleton variable
  it 'is an orm' do
    expect(TM.orm).to be_a(TM::ORM)
  end

  #this directs it to the correct database
  it 'created with a db adaptor' do
    expect(TM.orm.db_adaptor).not_to be_nil
  end

#now we are testing our methods
  describe '#add_employee' do
    it 'creates a new employee with name and returns a employee instance' do
      expect(TM.orm.add_employee('Tom')).to be_a(Employee)
  end
#
  describe '#list_employees' do
    it 'lists the employees in the database' do
      TM.orm.add_employee('jon')
      TM.orm.add_employee('britney')
      expect(TM.orm.list_employees.map{|employee| employee.name}).should include('jon', 'britney')
    end
  end
#
  describe '#remove_employee' do
    it 'removes the employee in the database' do
      jon = TM.orm.add_employee('jon')
      TM.orm.add_employee('britney')
      TM.orm.remove_employee(jon.id)
      expect(TM.orm.list_employees.map{|employee| employee.name}).should_not include('jon')
    end
  end

#
  let(:jon){TM.orm.add_employee('jon')}
  describe '#add_project' do
    it 'adds the project to the database and returns a Project instance' do
      expect(TM.orm.add_project('coffee', jon.id)).to be_a(Project)
    end
  end

  describe '#list_projects' do
    it 'lists the projects in the database' do
      TM.orm.add_project('coffee', jon.id)
      TM.orm.add_project('tea',jon.id)
      expect(TM.orm.list_projects.map{|project| project.name}).should include('tea', 'coffee')
    end
  end


  describe '#remove_project' do
    it 'removes the project in the database' do
      tea = TM.orm.add_project('tea', jon.id)
      TM.orm.add_project('coffee', jon.id)
      TM.orm.remove_project(tea.id,jon.id)
      expect(TM.orm.list_projects.map{|project| project.name}).should_not include('tea')
    end
  end
let(:tea){TM.orm.add_project('tea', jon.id)}
  describe '#add_task' do
    it 'adds the task to the database and returns a task instance' do
      expect(TM.orm.add_task(tea.id, 1, 'get coffee')).to be_a(task)
    end
  end

  describe '#list_tasks' do
    it 'lists the tasks in the database by project id or by employee id' do
      TM.orm.add_task(tea.id, 1, 'get coffee')
      TM.orm.add_task(tea.id, 0, 'get tea')
      expect(TM.orm.list_tasks(tea.id).map{|task| task.priority}).should include(1, 0)
      expect(TM.orm.list_tasks(jon.id).map{|task| task.priority}).should include(1, 0)
    end
  end

let(:test){TM.orm.add_task(tea.id, 1, 'get coffee')}

  describe '#mark_task_complete' do
    it 'marks a task as complete by project id and task id' do
      TM.orm.mark_task_complete(tea.id,test.id)
      expect(TM.orm.list_tasks(tea.id).map{|task| task.priority}).should_not include(1)
    end
    it 'or marks a task as complete by employee id and task id' do
      TM.orm.mark_task_complete(jon.id,test.id)
      expect(TM.orm.list_tasks(jon.id).map{|task| task.priority}).should_not include(1)
    end
  end

  describe '#assign_task' do
    it 'assigns a task to an employee' do
      britney = TM.orm.add_employee('britney')
      expect(list_tasks(britney.id).map{|task| task.priority}).should_not include(1)
      TM.orm.assign_task(britney.id, test.id)
      expect(list_tasks(britney.id).map{|task| task.priority}).should include(1)
    end
  end


  describe '#remove_task' do
    it 'removes the task in the database' do
      TM.orm.add_task(tea.id, 1, 'get coffee')
      TM.orm.add_task(tea.id, 0, 'get tea')
      TM.orm.remove_task(tea.id)
      expect(TM.orm.list_tasks(tea.id).map{|task| task.name}).should_not include('tea')
    end
  end






end

