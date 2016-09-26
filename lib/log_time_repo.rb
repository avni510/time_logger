module TimeLogger
  class LogTimeRepo
    attr_reader :entries

    def initialize(save_json_data)
      @save_json_data = save_json_data
      @entries = []
    end


    def create(employee_id, date, hours_worked, timecode, client=nil)
      if @entries.empty?
        log_entry_id = 1
      else
        log_entry_id = @entries[-1][0] + 1
      end
      
      log_entry = [ log_entry_id, employee_id, date, hours_worked, timecode, client ]

      @entries << log_entry
    end

    def find_by_employee_id(employee_id)
      total_entries_per_employee = []

      @entries.each do |entry|
        if entry[1] == employee_id
          total_entries_per_employee << entry
        end
      end

      total_entries_per_employee
    end

    def save
      @save_json_data.log_time(@entries)
    end
  end
end

