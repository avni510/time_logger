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
        log_entry_id = @entries.count + 1
      end

      log_time_entry = LogTimeEntry.new(log_entry_id, employee_id, date, hours_worked, timecode, client)

      @entries << log_time_entry
    end

    def find_by_employee_id(employee_id)
      total_entries_for_employee = []

      @entries.each do |entry|
        if entry.employee_id == employee_id
          total_entries_for_employee << entry
        end
      end

      total_entries_for_employee
    end

    def save
      @save_json_data.log_time(@entries)
    end
  end
end

