module DB
  class Setup
    @@db_hash = 
      {
        production: "time_logger",
        test: "time_logger_test"
      }

    def self.create(db_env)
      con = PG::Connection.open(:dbname => "postgres")
      db_name = @@db_hash[db_env]
      con.exec("CREATE DATABASE #{db_name}")
      con.close
    end

    def self.migrate(db_env)
      db_name = @@db_hash[db_env]
      con = PG::Connection.open(:dbname => db_name)
      con.exec("CREATE TABLE Clients
               (
                  ID SERIAL, 
                  Name varchar(255) NOT NULL,
                  PRIMARY KEY (ID)
               )"
              )
      con.exec("CREATE TABLE Employees
               (
                  ID SERIAL,
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
                  ID SERIAL,
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
      con.exec("INSERT INTO EMPLOYEES (username, admin) VALUES ('defaultadmin', 'true')")
      con.exec("INSERT INTO TIMECODES (id, timecode) VALUES (1, 'Non-Billable')")
      con.exec("INSERT INTO TIMECODES (id, timecode) VALUES (2, 'PTO')")
      con.exec("INSERT INTO TIMECODES (id, timecode) VALUES (3, 'Billable')")
      con.close
    end
  end
end
