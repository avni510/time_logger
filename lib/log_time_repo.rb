module TimeLogger
  class LogTimeRepo
    attr_reader :entries

    def initialize(save_json_data)
      @save_json_data = save_json_data
      @entries = []
    end


    def create(employee_id, date, hours_worked, timecode, client=nil)
      log_entry_id = @entries.count

      params = {
        "id": log_entry_id, 
        "employee_id": employee_id, 
        "date": date, 
        "hours_worked": hours_worked, 
        "timecode": timecode, 
        "client": client
      }

      log_time_entry = LogTimeEntry.new(params)

      @entries << log_time_entry
    end

    def find_by(employee_id, date=nil)
      if date == nil
        find_entries_for_employee_by(employee_id)
      else
        find_entries_for_date_by(employee_id, date)
      end
    end

    def save
      @save_json_data.log_time(@entries)
    end

    private 

    def find_entries_for_date_by(employee_id, date)
      entries_for_employee_for_date = []

      @entries.each do |entry|
        if entry.employee_id == employee_id && entry.date == date
          entries_for_employee_for_date << entry
        end
      end

      entries_for_employee_for_date 
    end

    def find_entries_for_employee_by(employee_id)
      total_entries_for_employee = []

      @entries.each do |entry|
        if entry.employee_id == employee_id
          total_entries_for_employee << entry
        end
      end

      total_entries_for_employee
    end
  end
end

