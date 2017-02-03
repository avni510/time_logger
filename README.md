Time Logger
-----------
Time Logger employee application for businesses written in Ruby. 


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
$ bundle install
```

Run application console application
```
$ ./bin/execute_time_logger_console.rb
```

Run Web App
```
$ rackup 
```
Usage
-----
The application is used for employees to log their time worked 

Default Admin
-----
The default admin username is 'defaultadmin'

Persisting Data
--------------
There are two ways to persist data. To a flat file in JSON format or to a Postgresql database. 

Here are steps for using the flat file

Here are the steps for using the Postgresql database 
1. Start your Postgresql server
2. `$ rake:db_create`
3. `$ rake:db_migrate`

Test Suite
----------
Please start your Postgresql server and run the migration prior to run the test suite then run
```
$ rspec
```

First Version of Time Logger
-----
As this is the first version of the Time Logger it has limited functionality
* Users are only able to enter integers for hours worked (no decimals)
* The program is case sensitive for employee usernames and client usernames
(ex: you can enter employee_username and Employee_username and it will create
2 different users)
* spaces after your input will cause the input to be invalid
