module TimeLogger
  class LogTimeRepo
    attr_reader :entries

    def initialize(save_json_data)
      @save_json_data = save_json_data
      @entries = []
    end

    def create(params)
      log_entry_id = @entries.count + 1

      log_entry_params = generate_log_entry_hash(log_entry_id, params)

      log_time_entry = LogTimeEntry.new(log_entry_params)

      @entries << log_time_entry
    end

    def find_by(id)
      @entries.each do |entry|
        return entry if entry.id == id
      end
      nil
    end

    def save
      @save_json_data.log_time(@entries)
    end

    def all
      @entries
    end

    def find_by_employee_id(employee_id)
      filtered_entries = @entries.select do |entry|
        entry.employee_id == employee_id 
      end
      
      entries_empty?(filtered_entries)
    end

    def find_total_hours_worked_for_date(employee_id, date_string)
      entries_by_date = find_by_employee_id_and_date(employee_id, date_string)

      aggregate_total_hours_worked(entries_by_date)
    end

  
    def find_by_employee_id_and_date(employee_id, date_string)
      date = Date.strptime(date_string,'%m-%d-%Y')
      filtered_entries = @entries.select { |entry| 
        entry.employee_id == employee_id && 
        entry.date == date
      }

      entries_empty?(filtered_entries)
    end

    def sorted_current_month_entries_by_employee_id(employee_id)
      entries_by_employee = find_by_employee_id(employee_id)

      return nil unless entries_by_employee

      current_month_entries = filter_for_current_month(entries_by_employee)
      sorted_entries = sort_log_times_by_date(current_month_entries)

      entries_empty?(sorted_entries)
    end

    def employee_client_hours(employee_id)
      sorted_entries = sorted_current_month_entries_by_employee_id(employee_id)

      return {} unless sorted_entries

      entries_with_clients = filter_entries_with_clients(sorted_entries)

      create_employee_clients_hash(entries_with_clients)
    end

    def employee_timecode_hours(employee_id)
      sorted_entries = sorted_current_month_entries_by_employee_id(employee_id)

      return {} unless sorted_entries

      create_employee_timecode_hash(sorted_entries)
    end

    def company_timecode_hours
      filtered_entries = filter_for_current_month(@entries)
      
      company_timecode_hash = create_company_timecode_hash(filtered_entries)

      entries_empty?(company_timecode_hash)
    end

    def company_client_hours
      filtered_entries = filter_for_current_month(@entries)

      client_entries = filter_entries_with_clients(filtered_entries)

      company_client_hash = create_company_client_hash(client_entries)

      entries_empty?(company_client_hash)
    end

    def filter_for_current_month(entries)
      today = Date.today
      entries.reject do |log_time|
        log_time.date.month < today.month ||
        log_time.date.year < today.year 
      end
    end

    private 

    def aggregate_total_hours_worked(entries_by_date)
      total_hours_worked = 0

      return total_hours_worked unless entries_by_date

      entries_by_date.each do |entry|
        total_hours_worked += entry.hours_worked
      end

      total_hours_worked
    end

    def generate_log_entry_hash(log_entry_id, params)
      {
        "id": log_entry_id,
        "employee_id": params[:employee_id], 
        "date": Date.strptime(params[:date],'%Y-%m-%d'),
        "hours_worked": params[:hours_worked].to_i, 
        "timecode": params[:timecode], 
        "client": params[:client]
      }
    end

    def filter_entries_with_clients(entries)
      entries.reject { |log_time| log_time.client.nil? }
    end
    
    def create_company_client_hash(entries)
      array_of_client_name_and_hours = client_name_and_hours(entries)
      populate_hash(array_of_client_name_and_hours)
    end

    def create_company_timecode_hash(entries)
      array_of_timecode_name_and_hours = timecode_and_hours(entries)
      populate_hash(array_of_timecode_name_and_hours)
    end

    def create_employee_clients_hash(entries)
      array_of_client_name_and_hours = client_name_and_hours(entries)
      populate_hash(array_of_client_name_and_hours)
    end

    def create_employee_timecode_hash(entries)
      array_of_timecode_name_and_hours = timecode_and_hours(entries)
      populate_hash(array_of_timecode_name_and_hours)
    end

    def timecode_and_hours(entries)
      timecodes_array = []
      entries.each do |entry|
        timecodes_array << [entry.timecode, entry.hours_worked]
      end
      timecodes_array
    end
    
    def client_name_and_hours(entries)
      clients_array = []

      entries.each do |entry|
        clients_array << [entry.client, entry.hours_worked]
      end
      clients_array
    end

    def populate_hash(array_of_attribute_and_hours_worked)
      item_hash = {}
      array_of_attribute_and_hours_worked.each do |(attribute, hours)|
        if item_hash.include?(attribute)
          item_hash[attribute] += hours
        else
          item_hash[attribute] = hours
        end
      end
      item_hash
    end

    def entries_empty?(entries)
      entries.empty? ? nil : entries
    end

    def sort_log_times_by_date(entries)
      entries.sort_by do |log_time_entry|
        log_time_entry.date
      end
    end

  end
end

