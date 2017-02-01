module SQL
  class LogTimeRepo
    def initialize(db_connection)
      @connection = db_connection
    end

    def create(params)
      log_time_hash = generate_log_entry_db_hash(params)
      if params[:client]
        @connection.exec(
          "INSERT INTO LOGTIMES 
           (emp_id, date, hours_worked, timecode_id, client_id) select 
           #{log_time_hash[:employee_id]}, 
           '#{log_time_hash[:date]}', #{log_time_hash[:hours_worked]}, 
           (SELECT id FROM TIMECODES WHERE timecode='#{log_time_hash[:timecode]}'), 
           (SELECT id FROM CLIENTS WHERE name='#{params[:client]}')"
        )
      else
        @connection.exec(
          "INSERT INTO LOGTIMES 
           (emp_id, date, hours_worked, timecode_id, client_id) select 
           #{log_time_hash[:employee_id]}, 
           '#{log_time_hash[:date]}', #{log_time_hash[:hours_worked]}, 
           (SELECT id FROM TIMECODES WHERE timecode='#{log_time_hash[:timecode]}'), 
           NULL"
        )
      end
    end

    def find_by(id)
      result = @connection.exec(
        "SELECT TimecodesAndClients.* FROM (
           SELECT lt.id, lt.emp_id, lt.date, 
           lt.hours_worked, t.timecode, c.name 
           FROM LOGTIMES lt JOIN TIMECODES t on 
           lt.timecode_id=t.id LEFT JOIN ClIENTS c on lt.client_id=c.id) 
           as TimecodesAndClients 
         WHERE TimecodesAndClients.id=#{id}"
      )
      return nil if result.values.empty?
      log_entry_row = result.values[0]
      create_log_entry_object(log_entry_row)
    end

    def save
    end

    def all
      result = @connection.exec(
        "SELECT lt.id, lt.emp_id, lt.date, 
         lt.hours_worked, t.timecode, c.name 
         FROM LOGTIMES lt JOIN TIMECODES t on 
         lt.timecode_id=t.id LEFT JOIN CLIENTS c on lt.client_id=c.id"
      )
      return nil if result.values.empty?
      result.values.map do |log_time_row|
        create_log_entry_object(log_time_row)
      end
    end

    def find_by_employee_id(employee_id)
      result = @connection.exec(
        "SELECT TimecodesAndClients.* FROM (
           SELECT lt.id, lt.emp_id, lt.date, 
           lt.hours_worked, t.timecode, c.name 
           FROM LOGTIMES lt JOIN TIMECODES t on 
           lt.timecode_id=t.id LEFT JOIN CLIENTS c on lt.client_id=c.id) 
           as TimecodesAndClients
        WHERE timecodesandclients.emp_id=#{employee_id}")
      return nil if result.values.empty?
      result.values.map do |log_time_row|
        create_log_entry_object(log_time_row)
      end
    end

    def find_total_hours_worked_for_date(employee_id, date_string)
      date = Date.strptime(date_string,'%m-%d-%Y').to_s
      result = @connection.exec(
        "SELECT SUM(LOGTIMES.hours_worked) FROM 
         LOGTIMES WHERE date='#{date_string}' AND emp_id = #{employee_id}"
      )
      sum_hours = result.values[0][0].to_i
    end
  
    def sorted_current_month_entries_by_employee_id(employee_id)
      result = @connection.exec(
        "SELECT TimecodesAndClients.* FROM (
           SELECT lt.id, lt.emp_id, lt.date,
           lt.hours_worked, t.timecode, c.name
           FROM LOGTIMES lt JOIN TIMECODES t on
           lt.timecode_id=t.id LEFT JOIN ClIENTS c on lt.client_id=c.id)
           as TimecodesAndClients
         WHERE TimecodesAndClients.emp_id=#{employee_id} 
         AND date_trunc('month', TimecodesAndClients.date)=date_trunc('month', CURRENT_DATE) 
         ORDER BY TimecodesAndClients.date"
      )
      return nil if result.values.empty?
      result.values.map do |log_time_row|
        create_log_entry_object(log_time_row)
      end
    end

    def employee_client_hours(employee_id)
      result = @connection.exec(
        "SELECT CurrentMonthEntries.name, SUM(CurrentMonthEntries.hours_worked) FROM (
           SELECT lt.emp_id, lt.date,
           lt.hours_worked, c.name
           FROM LOGTIMES lt JOIN ClIENTS c on lt.client_id=c.id)
           as CurrentMonthEntries
         WHERE CurrentMonthEntries.emp_id=#{employee_id} AND date_trunc(
         'month', CurrentMonthEntries.date)=date_trunc('month', CURRENT_DATE) 
         GROUP BY CurrentMonthEntries.name"
      )
      clients_hash = {}
      result.values.each do |client_row|
        clients_hash[client_row[0]] = client_row[1].to_i
      end
      clients_hash
    end

    def employee_timecode_hours(employee_id)
      result = @connection.exec(
        "SELECT CurrentMonthEntries.timecode, SUM(CurrentMonthEntries.hours_worked) FROM (
              SELECT lt.emp_id, lt.date,
              lt.hours_worked, t.timecode
              FROM LOGTIMES lt JOIN TIMECODES t on 
              lt.timecode_id = t.id)
              as CurrentMonthEntries
         WHERE CurrentMonthEntries.emp_id=#{employee_id} AND date_trunc(
         'month', CurrentMonthEntries.date)=date_trunc('month', CURRENT_DATE) 
         GROUP BY CurrentMonthEntries.timecode"
      )
      timecode_hash = {}
      result.values.each do |timecode_row|
        timecode_hash[timecode_row[0]] = timecode_row[1].to_i
      end
      timecode_hash
    end

    def company_timecode_hours
      result = @connection.exec(
        "SELECT t.timecode, SUM(lt.hours_worked)
        FROM LOGTIMES lt JOIN TIMECODES t on
        lt.timecode_id=t.id WHERE 
        date_trunc('month', lt.date) = date_trunc('month', CURRENT_DATE) 
        GROUP BY t.timecode"
      )
      timecode_hash = {}
      result.values.each do |timecode_row|
        timecode_hash[timecode_row[0]] = timecode_row[1].to_i
      end
      timecode_hash
    end

    def company_client_hours
      result = @connection.exec(
        "SELECT c.name, SUM(lt.hours_worked)
        FROM LOGTIMES lt JOIN ClIENTS c on lt.client_id=c.id WHERE
        date_trunc('month', lt.date) = date_trunc('month', CURRENT_DATE)
        GROUP BY c.name"
      )
      clients_hash = {}
      result.values.each do |client_row|
        clients_hash[client_row[0]] = client_row[1].to_i
      end
      clients_hash
    end

    private

    def generate_log_entry_db_hash(params)
      { 
        :employee_id => params[:employee_id], 
        :date =>  Date.strptime(params[:date],'%Y-%m-%d').to_s,
        :hours_worked => params[:hours_worked].to_i,
        :timecode => params[:timecode],
        :client => params[:client]
      }
    end

    def create_log_entry_object(values)
      log_entry_hash = {
        :id => values[0].to_i ,
        :employee_id => values[1].to_i,
        :date => Date.strptime(values[2], "%Y-%m-%d"),
        :hours_worked => values[3].to_i,
        :timecode => values[4], 
        :client => values[5]
      }
      TimeLogger::LogTimeEntry.new(log_entry_hash)
    end
  end
end
