Time Logger
-----------
Time Logger is an employee application for businesses written in Ruby. 

This application can either be run through the console or through the web, 
and data can be persisted either to a flat file or to a postgresql database.

Installation 
------------
Clone the git repository

```
$ git clone https://github.com/avni510/time_logger.git
```

Then `cd` into the directory

```
$ cd time_logger
```

Install dependencies

```
/time_logger $ bundle install
```

Run the Database Migration
-------------------------
Start your Postgresql server

Production Database

`$ rake db:create`

`$ rake db:migrate`

Test Database

`$ rake db_test:create`

`$ rake db_test:migrate`

Persisting Data
--------------
There are two ways to persist data. To a flat file in JSON format or to a Postgresql database. 

Here are steps for using the flat file:

in `lib/time_logger/console/console_runner.rb` (for the console) or in `config.ru` (for the web) uncomment the following lines 

```
file_wrapper = InMemory::FileWrapper.new(File.expand_path("data/" + "time_logger_data.json"))
json_store = InMemory::JsonStore.new(file_wrapper) 
json_store.load   
```

```
params = {
  :log_time_repo => InMemory::LogTimeRepo.new(json_store),
  :employee_repo => InMemory::EmployeeRepo.new(json_store),
  :client_repo => InMemory::ClientRepo.new(json_store)
}
```

```
RepositoryRegistry.setup(params)

employee_setup = EmployeeSetup.new(@console_ui)
employee_setup.run
```

```
at_exit {
  file_wrapper.write_data(json_store.data) 
}
```

Comment out the rest of the code. 

data is persisted in JSON format to `data/time_logger_data.json`

Here are the steps for using the Postgresql database: 

Please make sure your postgres server is running

in `lib/time_logger/console/console_runner.rb` (for the console) or in `config.ru` (for the web) uncomment the following lines 

```
connection = PG::Connection.open(:dbname => "time_logger") 
```

```
params = {
  :log_time_repo => SQL::LogTimeRepo.new(connection),
  :employee_repo => SQL::EmployeeRepo.new(connection),
  :client_repo => SQL::ClientRepo.new(connection)
}
```

```
RepositoryRegistry.setup(params)

employee_setup = EmployeeSetup.new(@console_ui)
employee_setup.run
```

```
at_exit {
   connection.close
}
```

Comment out the rest of the code. 


Run application
---------------

Run Console

```
/time_logger $ ./bin/execute_time_logger_console.rb
```

Run Web App

```
/time_logger $ rackup 
```


Usage
-----
The application is used for employees to log their time worked 

Default Admin
-----
The default admin username is 'defaultadmin'

Test Suite
----------
Please start your Postgresql server and run the migration prior to run the test suite then run

```
/time_logger $ rspec
```

First Version of Time Logger
-----
As this is the first version of the Time Logger it has limited functionality
* Users are only able to enter integers for hours worked (no decimals)
* The program is case sensitive for employee usernames and client usernames
(ex: you can enter employee_username and Employee_username and it will create
2 different users)
* spaces after your input will cause the input to be invalid
