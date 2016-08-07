require 'byebug'
class Zklib
  module AttendanceManagement
    # Get attendance list size
    def get_attendance_size
      if BinData::Uint16le.read(data_recv).snapshot == CMD_PREPARE_DATA
        BinData::Uint32le.read(data_recv[8..-1]).snapshot
      else
        0
      end
    end

    # Decode attendance data
    #
    # param  options
    #        |_ data  Attendance data to decode
    def decode_attendance_data(options)
      {
        uid:       options[:data][0..3].split("\0").pop.to_i,
        id:        options[:data][4..7].split("\0").pop.to_i,
        state:     BinData::Uint8le.read(options[:data][28]).snapshot,
        timestamp: decode_time({
          seconds: BinData::Uint32le.read(options[:data][29..-1]).snapshot
        })
      }
    end

    # Get attendance list from attendance machine
    def get_attendance
      header = create_header({
        command:        CMD_ATTLOG_RRQ,
        command_string: '',
        checksum:       0,
        session_id:     session_id,
        reply_id:       BinData::Uint16le.read(data_recv[6..-1]).snapshot
      })

      # Send command
      socket = UDPSocket.new
      socket.bind('0.0.0.0', inport)
      socket.send(header, 0, ip, port)

      ### START Get response size ###
      self.data_recv = receive_nonblock({
        socket: socket
      })[0]

      return puts 'ERROR: Empty response' unless data_recv && data_recv.length > 0

      self.session_id = BinData::Uint16le.read(data_recv[4..-1]).snapshot
      total_bytes = get_attendance_size

      # Stop if attendance list is empty
      if total_bytes <= 0
        socket.close

        return []
      end
      ### END Get response size ###

      ### START Get attendance list ###
      bytes_recv = 0
      rem = nil
      offset = 0
      attendance_data_size = 40
      trim_first = 10
      trim_others = 8
      attendances = []

      while true
        data = receive_nonblock({
          socket: socket
        })[0]

        if bytes_recv == 0
          offset = trim_first
          bytes_recv = 4
        else
          offset = trim_others
        end

        while(data.length - offset >= attendance_data_size)
          attendance_data = data[offset..-1]
          offset += attendance_data_size

          if rem && rem.length > 0
            attendance_data.prepend(rem)
            offset -= rem.length
            rem = nil
          end

          attendances << decode_attendance_data({
            data: attendance_data
          })
          bytes_recv += attendance_data_size

          if bytes_recv == total_bytes
            socket.close

            return attendances
          end
        end

        rem = data[offset..-1]
      end
      ### END Get attendance list ###

      socket.close
    end
  end
end
