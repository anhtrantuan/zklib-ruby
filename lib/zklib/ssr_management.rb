class Zklib
  module SSRManagement
    SSR_KEYWORD = '~SSR'

    # Get SSR
    def get_ssr
      execute_cmd(
        command:        CMD_DEVICE,
        command_string: SSR_KEYWORD
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 8
          data.split("\u0000").pop.tr("#{SSR_KEYWORD}=", '')
        else
          puts 'ERROR: Invalid SSR response'
        end
      end
    end
  end
end
