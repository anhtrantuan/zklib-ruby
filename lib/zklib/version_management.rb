class Zklib
  module VersionManagement
    OS_VERSION_KEYWORD       = '~OS'
    PLATFORM_VERSION_KEYWORD = '~ZKFPVersion'
    SSR_VERSION_KEYWORD      = '~SSR'

    # Get firmware version
    def get_firmware_version
      execute_cmd(
        command:        CMD_VERSION,
        command_string: ''
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 8
          data.split("\u0000").pop
        else
          puts 'ERROR: Invalid firmware version response'
        end
      end
    end

    # Get OS version
    def get_os_version
      execute_cmd(
        command:        CMD_DEVICE,
        command_string: OS_VERSION_KEYWORD
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 8
          data.split("\u0000").pop.tr("#{OS_VERSION_KEYWORD}=", '')
        else
          puts 'ERROR: Invalid OS version response'
        end
      end
    end

    # Get platform version
    def get_platform_version
      execute_cmd(
        command:        CMD_DEVICE,
        command_string: PLATFORM_VERSION_KEYWORD
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 8
          data.split("\u0000").pop.tr("#{PLATFORM_VERSION_KEYWORD}=", '')
        else
          puts 'ERROR: Invalid platform version response'
        end
      end
    end
  end
end
