class Zklib
  module VersionManagement
    VERSION_KEYWORD = '~ZKFPVersion'

    # Get version of attendance machine
    def version
      execute_cmd({
        command:        CMD_DEVICE,
        command_string: VERSION_KEYWORD
      }){ |opts|
        if opts[:valid]
          opts[:data].split("\u0000").pop.tr("#{VERSION_KEYWORD}=", '')
        else
          puts "ERROR: #{options[:error]}"
        end
      }
    end
  end
end
