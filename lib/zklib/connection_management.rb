class Zklib
  module ConnectionManagement
    # Connect to attendance machine
    def connect
      execute_cmd(
        command:        CMD_CONNECT,
        command_string: ''
      ) do |opts|
        check_valid(data: opts[:data])
      end
    end

    # Disconnect from attendance machine
    def disconnect
      execute_cmd(
        command:        CMD_EXIT,
        command_string: ''
      ) do |opts|
        check_valid(data: opts[:data])
      end
    end
  end
end
