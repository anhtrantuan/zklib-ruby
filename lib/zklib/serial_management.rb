class Zklib
  module SerialManagement
    SERIAL_KEYWORD = '~SerialNumber'

    # Get serial number of attendance machine
    def get_serial_number
      execute_cmd({
        command:        CMD_DEVICE,
        command_string: SERIAL_KEYWORD
      }){ |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        if opts[:data].length > 8
          opts[:data].split("\u0000").pop.tr("#{SERIAL_KEYWORD}=", '')
        else
          puts 'ERROR: Invalid serial number response'
        end
      }
    end
  end
end
