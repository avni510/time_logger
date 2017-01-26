require 'pg'
module DB
  class Setup

    def self.create
      con = PG::Connection.open(:dbname => "postgres")
      con.exec("CREATE DATABASE time_logger")
      con.close
    end

    def self.migrate
      con = PG::Connection.open(:dbname => "time_logger")
      con.exec("CREATE TABLE Clients
               (
                  ID int NOT NULL, 
                  Name varchar(255) NOT NULL,
                  PRIMARY KEY (ID)
               )"
              )
      con.exec("CREATE TABLE Employees
               (
                  ID int NOT NULL,
                  Username varchar(255) NOT NULL,
                  Admin boolean NOT NULL,
                  PRIMARY KEY (ID)
                )"
              )

      con.exec("CREATE TABLE Timecodes
               (
                  ID int NOT NULL,
                  Timecode varchar(255) NOT NULL,
                  PRIMARY KEY (ID)
                )"
              )

      con.exec("CREATE TABLE LogTimes
               (
                  ID int NOT NULL,
                  Emp_ID int NOT NULL,
                  Date date NOT NULL,
                  Hours_worked int NOT NULL,
                  Timecode_ID int NOT NULL,
                  Client_ID int,
                  PRIMARY KEY (ID),
                  FOREIGN KEY (Emp_ID) REFERENCES Employees(ID),
                  FOREIGN KEY (Client_ID) REFERENCES Clients(ID) ,
                  FOREIGN KEY (Timecode_ID) REFERENCES Timecodes(ID)
                )"
              )
      con.exec("INSERT INTO EMPLOYEES (id, username, admin) VALUES (1, 'defaultadmin', 'true')")
      con.close
    end
  end
end
