class Zklib
  module WorkCodeManagement
    WORK_CODE_KEYWORD = 'WorkCode'
    
    # Get work code
    def get_work_code
      execute_cmd(
        command:        CMD_DEVICE,
        command_string: WORK_CODE_KEYWORD
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 8
          data.split("\u0000").pop.tr("#{WORK_CODE_KEYWORD}=", '')
        else
          puts 'ERROR: Invalid work code response'
        end
      end
    end
  end
end
