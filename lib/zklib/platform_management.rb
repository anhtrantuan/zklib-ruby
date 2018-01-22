class Zklib
  module PlatformManagement
    PLATFORM_KEYWORD = '~Platform'

    # Get platform
    def get_platform
      execute_cmd(
        command:        CMD_DEVICE,
        command_string: PLATFORM_KEYWORD
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 8
          data.split("\u0000").pop.tr("#{PLATFORM_KEYWORD}=", '')
        else
          puts 'ERROR: Invalid platform response'
        end
      end
    end
  end
end
