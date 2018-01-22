class Zklib
  module DeviceManagement
    DEVICE_NAME_KEYWORD    = '~DeviceName'
    DISABLE_DEVICE_KEYWORD = "\u0000\u0000"

    # Disable attendance machine
    def disable_device
      execute_cmd(
        command:        CMD_DISABLEDEVICE,
        command_string: DISABLE_DEVICE_KEYWORD
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 7
          data.split("\u0000").pop
        else
          puts 'ERROR: Invalid disable device response'
        end
      end
    end

    # Enable attendance machine
    def enable_device
      execute_cmd(
        command:        CMD_ENABLEDEVICE,
        command_string: ''
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 7
          data.split("\u0000").pop
        else
          puts 'ERROR: Invalid enable device response'
        end
      end
    end

    # Get device name
    def get_device_name
      execute_cmd(
        command:        CMD_DEVICE,
        command_string: DEVICE_NAME_KEYWORD
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 8
          data.split("\u0000").pop.tr("#{DEVICE_NAME_KEYWORD}=", '')
        else
          puts 'ERROR: Invalid device name response'
        end
      end
    end

    # Turn off attendance machine
    def power_off_device
      execute_cmd(
        command:        CMD_POWEROFF,
        command_string: ''
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 7
          data.split("\u0000").pop
        else
          puts 'ERROR: Invalid power off device response'
        end
      end
    end

    # Restart attendance machine
    def restart_device
      execute_cmd(
        command:        CMD_RESTART,
        command_string: ''
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 7
          data.split("\u0000").pop
        else
          puts 'ERROR: Invalid restart device response'
        end
      end
    end
  end
end
