class Zklib
  module ConnectionManagement
    # Connect to attendance machine
    def connect
      execute_cmd({
        command:        CMD_CONNECT,
        command_string: ''
      })
    end

    # Disconnect from attendance machine
    def disconnect
      execute_cmd({
        command:        CMD_EXIT,
        command_string: ''
      })
    end
  end
end
