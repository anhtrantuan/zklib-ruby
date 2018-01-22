class Zklib
  module TimeManagement
    # Get current time of attendance machine
    def get_time
      execute_cmd(
        command:        CMD_GET_TIME,
        command_string: ''
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 8
          decode_time(seconds: BinData::Uint32le.read(data[8..-1]).snapshot)
        else
          puts 'ERROR: Invalid time response'
        end
      end
    end

    # Set current time for attendance machine
    def set_time(time = Time.now)
      seconds        = encode_time(time: time)
      command_buffer = StringIO.new
      binary_writer  = BinData::Uint32le.new

      # Write command string
      binary_writer.value = seconds
      command_buffer.pos  = 0
      binary_writer.write(command_buffer)
      command_string = command_buffer.string

      execute_cmd(
        command:        CMD_SET_TIME,
        command_string: command_string
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 7
          data.split("\u0000").pop
        else
          puts 'ERROR: Invalid time response'
        end
      end
    end
  end
end
