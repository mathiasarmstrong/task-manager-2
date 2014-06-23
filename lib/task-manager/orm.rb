require 'pg'
require 'pry-byebug'

module TM
  class ORM
    attr_reader :db_adaptor

    def initialize
      @db_adaptor = PG.connect( host: 'localhost', dbname: 'task-manager-db' )
    end

#--------database initialization----------

    def create_tables
      command = <<-SQL
      CREATE TABLE projects(
        id SERIAL,
        name TEXT,
        PRIMARY KEY ( id )
        );

      CREATE TABLE employees(
        id SERIAL,
        name TEXT,
        PRIMARY KEY ( id )
        );

      CREATE TABLE tasks(
        id SERIAL,
        description TEXT,
        priority_number INTEGER,
        project_id INTEGER REFERENCES projects( id ),
        employee_id INTEGER REFERENCES employees( id ),
        creation_date TIMESTAMP,
        completed BOOLEAN,
        PRIMARY KEY ( id )
        );

      CREATE TABLE join_table(
        id SERIAL,
        project_id INTEGER REFERENCES projects( id ),
        employee_id INTEGER REFERENCES employees( id ),
        PRIMARY KEY ( id )
        );
      SQL

      @db_adaptor.exec( command )
      return nil
    end

    def drop_tables
      command=<<-SQL
        DROP TABLE tasks;
        DROP TABLE join_table;
        DROP TABLE employees;
        DROP TABLE projects;
      SQL
      @db_adaptor.exec( command )
      return nil
    end

    def reset_tables
      command=<<-SQL
        TRUNCATE TABLE tasks;
        TRUNCATE TABLE join_table;
        TRUNCATE TABLE employees CASCADE;
        TRUNCATE TABLE projects CASCADE;
      SQL
      @db_adaptor.exec( command )
      return nil
    end

#---------employee methods------------------

    def add_employee( name )
      command = <<-SQL
        INSERT INTO employees ( name )
        VALUES ( '#{name}'  )
        returning *;
      SQL
      result = @db_adaptor.exec( command ).values[0]
      Employee.new( result[0].to_i, result[1] )
    end

    def select_employee( eid )
      command = <<-SQL
        SELECT * FROM employees
        WHERE id = '#{ eid }'
      SQL
      @db_adaptor.exec(command)
    end

    def list_employees
      command = <<-SQL
        SELECT * FROM employees;
      SQL
      result = @db_adaptor.exec( command ).values
      employees = []
      result.each do |employee|
        employees << Employee.new( employee[0], employee[1] )
      end
      employees
    end

    def list_employees_by_project( pid )
      command = <<-SQL
        SELECT e.id, e.name
        FROM employees e
        JOIN join_table ep
        ON e.id = ep.employee_id
        JOIN projects p
        ON p.id = ep.project_id
        WHERE p.id = '#{ pid }'
        ;
      SQL
      result = @db_adaptor.exec( command ).values
      employees = []
      result.each do |employee|
        employees<< Employee.new( employee[0].to_i, employee[1] )
      end
      employees
    end

    def remove_employee( eid )
      command = <<-SQL
        DELETE FROM employees
        WHERE id = '#{ eid }';
      SQL
      @db_adaptor.exec( command )
      return nil
    end

#----------project methods------------------

    def add_project( name, eid = nil )
      command = <<-SQL
        INSERT INTO projects ( name )
        VALUES ( '#{ name }' )
        returning *;
      SQL
      result = @db_adaptor.exec( command ).values[0]
      pro = Project.new( result[1], result[0].to_i )
      add_employee_to_project( result[0].to_i, eid ) unless eid.nil?
      return pro
    end

    def select_project( pid )
      command = <<-SQL
        SELECT * FROM projects
        WHERE id = '#{ pid }'
      SQL
      project = @db_adaptor.exec(command).values[0]
      Project.new( project[1], project[0].to_i ) unless project.nil?
    end

    def list_projects
      command = <<-SQL
        SELECT * FROM projects;
      SQL
      result = @db_adaptor.exec( command ).values
      projects=[]
      result.each do |project|
        projects<< Project.new( project[1], project[0].to_i )
      end
      projects
    end

    def list_projects_by_employee( eid )
      command = <<-SQL
        SELECT p.id, p.name
        FROM projects p
        JOIN join_table ep
        ON p.id = ep.project_id
        JOIN employees e
        ON e.id = ep.employee_id
        WHERE e.id = '#{ eid }'
        ;
      SQL
      result = @db_adaptor.exec(command).values
      projects = []
      result.each do |project|
        projects<< Project.new( project[1], project[0].to_i )
      end
      projects
    end

    def add_employee_to_project( pid, eid )
      unless TM::Project.select( pid ).nil?
        command = <<-SQL
          INSERT INTO join_table ( project_id, employee_id )
          VALUES ( '#{ pid }', '#{ eid }' );
        SQL
        db_adaptor.exec(command)
      end
      return nil
    end

    def remove_employee_from_project( eid, pid )
      command = <<-SQL
        DELETE FROM join_table
        WHERE project_id = '#{ pid }', employee_id = '#{ eid }';
      SQL
      return nil
    end

    def remove_project( pid )
      command = <<-SQL
        DELETE FROM join_table
        WHERE project_id = '#{ pid }';
        DELETE FROM projects
        WHERE id = '#{ pid }';
      SQL
      @db_adaptor.exec( command )
      return nil
    end

#--------task methods-----------------------------

    def add_task( description, priority, pid, eid = nil )
      unless TM::Project.select( pid ).nil?
        command = <<-SQL
          INSERT INTO tasks ( description, priority_number, project_id, employee_id, creation_date, completed)
          VALUES ( '#{ description }', '#{ priority }', '#{ pid }', '#{ eid }', '#{Time.now}', 'false')
          returning *;
        SQL
        result = @db_adaptor.exec( command ).values[0]
        Task.new( result[0].to_i, result[1], result[2].to_i,
          result[3].to_i, result[4].to_i, result[5], result[6]=='t' )
      end
    end

    def select_task( tid )
      command = <<-SQL
      SELECT * FROM tasks
      WHERE id = '#{ tid }'
      SQL
      result = db_adaptor.exec(command).values[0]
      Task.new( result[0].to_i, result[1], result[2].to_i,
        result[3].to_i, result[4].to_i, result[5], result[6]=='t' )
    end

    def list_tasks
      command = <<-SQL
        SELECT * FROM tasks;
      SQL
      result = @db_adaptor.exec( command ).values
      tasks=[]
      result.each do |task|
        tasks<< Task.new( task[0].to_i, task[1], task[2].to_i,
          task[3].to_i, task[4].to_i, task[5], task[6] == 't' )
      end
      tasks
    end

    def assign_task( eid, tid )
      command = <<-SQL
        UPDATE tasks
        SET employee_id = '#{ eid }'
        WHERE id = '#{ tid }';
      SQL
      @db_adaptor.exec( command )
      nil
    end

    def mark_task_complete( tid )

      command = <<-SQL
        UPDATE tasks
        SET completed = 'true'
        WHERE id = '#{ tid }'
      SQL
      @db_adaptor.exec( command )
      nil
    end

    def remove_task( tid )
      command = <<-SQL
        DELETE FROM tasks
        WHERE id = '#{ tid }'
      SQL
      @db_adaptor.exec( command )
      nil
    end
  end

  def self.orm
    @__db_instance ||= ORM.new
  end

end
