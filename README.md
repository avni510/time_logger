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
$ ./bin/execute_time_logger_web.rb
```
Usage
-----
The application is used for employees to log in their time worked 

Default Admin
-----
The default admin username is 'defaultadmin'

Test Suite
----------
Executing the test suite
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
