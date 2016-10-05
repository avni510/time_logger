require 'pry'
module TimeLogger
  class LogTime
    def initialize(console_ui, validation)
      @console_ui = console_ui
      @validation = validation
    end

    def execute(employee_id)
      log_date 
      log_hours_worked(employee_id)

      all_client_objects = client_repo.all

      log_timecode(all_client_objects)

      if @timecode_entered == "Billable"
        select_clients(all_client_objects)
      end

      log_times_hash = generate_log_times_hash(
          employee_id, 
          @date_entered, 
          @hours_entered, 
          @timecode_entered, 
          @client
        )
      log_time_repo.create(log_times_hash)
      log_time_repo.save
    end

    private

    def log_time_repo
      Repository.for(:log_time)
    end

    def client_repo
      Repository.for(:client)
    end

    def generate_log_times_hash(employee_id, date, hours_worked, timecode, client)
      params = 
        { 
          "employee_id": employee_id,
          "date": Date.strptime(date, '%m-%d-%Y').to_s,
          "hours_worked": hours_worked,
          "timecode": timecode, 
          "client": client
        }
    end

    def select_clients(all_clients)
      clients_hash = generate_clients_hash(all_clients)
      @console_ui.display_menu_options(clients_hash)
      user_client_selection = @console_ui.get_user_input
      until clients_hash.has_key?(user_client_selection.to_i)
        @console_ui.invalid_client_selection_message
        user_client_selection = @console_ui.get_user_input
      end
      client = clients_hash[user_client_selection.to_i]
      @client = client[3..-1]
    end

    def log_date
      @date_entered = @console_ui.date_log_time_message
      @date_entered = valid_date_format_loop
      future_date_loop
    end

    def log_hours_worked(employee_id)
      @hours_entered = @console_ui.hours_log_time_message
      @hours_entered = digit_loop
      exceeds_hours_in_a_day(employee_id)
    end

    def log_timecode(all_clients)
      if all_clients.empty?
        @console_ui.no_clients_message
        timecode_options_hash = generate_timecode_hash_without_billable
      else
        timecode_options_hash = generate_timecode_hash_with_billable
      end
      timecode_num_entered = @console_ui.timecode_log_time_message(timecode_options_hash)
      timecode_num_entered = valid_timecode_loop(timecode_options_hash, timecode_num_entered)
      timecode_type = timecode_options_hash[timecode_num_entered.to_sym]
      @timecode_entered = timecode_type[3..-1]
    end

    def valid_date_format_loop
      until @validation.date_valid_format?(@date_entered)
        @console_ui.valid_date_message
        @date_entered = @console_ui.get_user_input
      end
      @date_entered
    end
    
    def future_date_loop
      until @validation.previous_date?(@date_entered)
        @console_ui.future_date_valid_message
        @date_entered = @console_ui.get_user_input
      end
      @date_entered
    end

    def digit_loop
      until @validation.digit_entered?(@hours_entered)
        @console_ui.enter_digit_message
        @hours_entered = @console_ui.get_user_input
      end
      @hours_entered
    end

    def exceeds_hours_in_a_day(employee_id)
      hours_worked = log_time_repo.find_total_hours_worked_for_date(employee_id, @date_entered)
      integer_hours = @hours_entered.to_i
      unless @validation.hours_worked_per_day_valid?(hours_worked, integer_hours)
        @console_ui.valid_hours_message
        execute(employee_id)
      end
      @hours_entered
    end

    def valid_timecode_loop(timecode_options_hash, timecode_entered)
      until @validation.menu_selection_valid?(timecode_options_hash, timecode_entered)
        @console_ui.valid_menu_option_message
        timecode_entered = @console_ui.get_user_input
      end
      timecode_entered
    end

    def generate_clients_hash(client_objects)
      clients_hash = {}
      client_objects.each do |client|
        clients_hash[client.id] = "#{client.id}. #{client.name}"
      end
      clients_hash
    end

    def generate_timecode_hash_without_billable
      { 
        "1": "1. Non-Billable",
        "2": "2. PTO"
      }
    end

    def generate_timecode_hash_with_billable
      { 
        "1": "1. Billable", 
        "2": "2. Non-Billable",
        "3": "3. PTO"
      }
    end
  end
end
