class Zklib
  module DataManagement
    # Free data for transmission
    def free_data
      execute_cmd(
        command:        CMD_FREE_DATA,
        command_string: ''
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 7
          data.split("\u0000").pop
        else
          puts 'ERROR: Invalid free data response'
        end
      end
    end

    # Refresh data for transmission
    def refresh_data
      execute_cmd(
        command:        CMD_REFRESHDATA,
        command_string: ''
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 7
          data.split("\u0000").pop
        else
          puts 'ERROR: Invalid refresh data response'
        end
      end
    end
  end
end
