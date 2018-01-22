class Zklib
  module FaceManagement
    TURN_FACE_OFF_KEYWORD = 'FaceFunOff'
    TURN_FACE_ON_KEYWORD  = 'FaceFunOn'

    # Turn face off
    def turn_face_off
      execute_cmd(
        command:        CMD_DEVICE,
        command_string: TURN_FACE_OFF_KEYWORD
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 7
          data.split("\u0000").pop
        else
          puts 'ERROR: Invalid turn face off response'
        end
      end
    end

    # Turn face on
    def turn_face_on
      execute_cmd(
        command:        CMD_DEVICE,
        command_string: TURN_FACE_ON_KEYWORD
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 7
          data.split("\u0000").pop
        else
          puts 'ERROR: Invalid turn face on response'
        end
      end
    end
  end
end
