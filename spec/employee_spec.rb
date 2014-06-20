describe 'Employee' do
  context 'creating a new Employee' do

    it 'creates an instance of the Employee class with a name and id number' do
      test = Employee.new('tom')
      expect(test.name).to eq('tom')
      expect(test.id).to be_a(Fixnum)
    end
  end

  describe '#create_new_project' do
    let(:test){Employee.new('tom')}
    context 'creates a new project using a name' do

      it 'gets the name and an id' do
        project = test.create_new_project('first')
        expect(project.name).to eq('first')
        expect(project.id).to be_a(Fixnum)
      end

      it 'adds the project to your projects' do
        expect(test.projects).to eq(0)
        project = test.create_new_project('first')
        expect(test.projects).to eq(1)
      end
    end
  end


  describe '#join_project' do

    let(:test){Employee.new('tom')}

    context 'when adding a person to a project' do

      it 'confirms that the project exists' do
        emp2 = Employee.new('john')
        test.join_project(emp2.id, project.id)
        expect(emp2.projects.count).to eq(0)
      end

      it 'makes sure that you have access to the project' do
        emp2 = Employee.new('john')
        emp3 = Employee.new('andrew')
        project = emp2.create_new_project('johns project')
        test.join_project(emp3.id, project.id)
        expect(emp3.projects.count).to eq(0)
        expect(test.projects.count).to eq(0)
        expect(emp2.projects.count).to eq(1)
      end

      it 'then adds the project to the employees project list' do
        project = test.create_new_project('first')
        emp2 = Employee.new('john')
        test.join_project(emp2.id, project.id)
        expect(emp2.projects.count).to eq(1)
      end
    end
  end


  describe '#create_new_task' do

    let(:test){Employee.new('tom')}

    context 'when creating a new task with a description and project id and priority number' do
      it 'gets an id number' do
        project = test.create_new_project('first')

        task = test.create_new_task(project.id, 0, 'this is a new task')

        expect(task.id).to be_a(Fixnum)
        expect(task.description).to eq('this is a new task')
        expect(task.project_id).to eq(project.id)
      end

      it 'is added to your tasks' do
        expect(test.tasks).to eq(0)
        project = test.create_new_project('first')
        task = test.create_new_task(project.id, 0, 'this is a new task')
        expect(test.tasks).to eq(1)
      end
    end
  end

  describe '#assign_task' do
    let(:test){Employee.new('tom')}
    context 'when assiging or reassigning a task' do
      it 'confirms the task exists' do
        emp2 = Employee.new('john')
        test.assign_task(emp2.id, task.id)
        expect(emp2.tasks.count).to eq(0)
      end
    end
  end

end
