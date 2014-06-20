module TM
  class ORM
    attr_reader :db_adaptor
    def initialize
      @db_adaptor = PG.connect(host: 'localhost', dbname: 'task-manager-db')
    end

    def create_tables
      command=<<-SQL
      CREATE TABLE projects(
        id SERIAL,
        name TEXT,
        PRIMARY KEY ( id )
        );

      CREATE TABLE tasks(
        id SERIAL,
        description TEXT,
        priority_number INTEGER,
        project_id INTEGER REFERENCES projects( id )
        );

      CREATE TABLE employees(
        id SERIAL,
        name TEXT,
        PRIMARY KEY ( id )
        );

      CREATE TABLE join_table(
        project_id INTEGER REFERENCES projects( id ),
        employee_id INTEGER REFERENCES employees( id )
        );
      SQL
      @db_adaptor.exec( command ).values
      return nil
    end

    def drop_tables
      command=<<-SQL
      DROP TABLE tasks;
      DROP TABLE join_table;
      DROP TABLE employees;
      DROP TABLE projects;
      SQL
      @db_adaptor.exec( command ).values
      return nil
    end

    def add_employee(name)
      command = <<-SQL
        INSERT INTO employees (name)
        VALUES ( '#{name}'  )
        returning *;
      SQL
      result = @db_adaptor.exec( command ).values[0]
      Employee.new(result[0],result[1])
    end

    def list_employees
      command = <<-SQL
        SELECT * FROM employees;
      SQL
      result = @db_adaptor.exec(command).values
      employees=[]
      result.each do |employee|
        employees<< TM::employee.new(employee[0],employee[1])
      end
      employees
    end

    def remove_employee(EID)
      command = <<-SQL
        DELETE FROM employees
        WHERE id = '#{EID}'
      SQL
      @db_adaptor.exec( command )
      return nil
    end

    def add_project(name)
      command = <<-SQL
        INSERT INTO projects (name)
        VALUES ( '#{name}' )
        returning id;
      SQL
      result = @db_adaptor.exec( command ).values
    end

    def list_projects
      command = <<-SQL
        SELECT * FROM projects;
      SQL
      result = @db_adaptor.exec(command).values
      projects=[]
      result.each do |project|
        projects<< TM::Project.new(project[0],project[1])
      end
      projects
    end

    def add_employee_to_project(eid,pid)
    end

    def remove_employee_from_project(eid,pid)
    end

    def remove_project(pid)
    end

    def add_task(pid,description)
    end

    def assign_task(eid, tid)
    end

    def mark_task_complete(pid,tid)
    end

    def remove_task(tid)
    end










  end

  def self.orm
    @__db_instance ||= DB.new
  end

end
