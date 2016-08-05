class Zklib
  module VersionManagement
    VERSION_KEYWORD = '~ZKFPVersion'

    # Get version of attendance machine
    def get_version
      execute_cmd({
        command:        CMD_DEVICE,
        command_string: VERSION_KEYWORD
      }){ |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        if opts[:data].length > 8
          opts[:data].split("\u0000").pop.tr("#{VERSION_KEYWORD}=", '')
        else
          puts 'ERROR: Invalid version response'
        end
      }
    end
  end
end
