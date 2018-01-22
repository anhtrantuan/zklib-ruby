class Zklib
  module PINManagement
    PIN_WIDTH_KEYWORD = '~PIN2Width'
    
    # Get PIN width
    def get_pin_width
      execute_cmd(
        command:        CMD_DEVICE,
        command_string: PIN_WIDTH_KEYWORD
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 8
          data.split("\u0000").pop.tr("#{PIN_WIDTH_KEYWORD}=", '')
        else
          puts 'ERROR: Invalid PIN width response'
        end
      end
    end
  end
end
