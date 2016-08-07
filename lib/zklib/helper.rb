class Zklib
  module Helper
    # Execute command on attendance machine
    #
    # param  options
    #        |_ command         Command to execute
    #        |_ command_string  Command string
    def execute_cmd(options)
      command = options[:command]
      self.reply_id = USHRT_MAX - 1 if command == CMD_CONNECT
      header = create_header({
        command:        command,
        checksum:       0,
        session_id:     session_id,
        reply_id:       reply_id,
        command_string: options[:command_string]
      })

      # Send command
      socket = UDPSocket.new
      socket.bind('0.0.0.0', inport)
      socket.send(header, 0, ip, port)
      self.data_recv = socket.recvfrom(65535)[0]
      socket.close

      # Callback
      if data_recv && data_recv.length > 0
        self.session_id = BinData::Uint16le.read(data_recv[4..-1]).snapshot
        self.reply_id = BinData::Uint16le.read(data_recv[6..-1]).snapshot

        yield({
          valid: true,
          data:  data_recv
        }) if block_given?
      else
        yield({
          valid: false,
          error: 'Empty response'
        }) if block_given?
      end
    end

    # Create header for execution
    #
    # param  options
    #        |_ command         Command value
    #        |_ checksum        Checksum
    #        |_ session_id      Session ID
    #        |_ reply_id        Reply ID
    #        |_ command_string  Command string
    def create_header(options)
      header_buffer = StringIO.new
      binary_writer = BinData::Uint16le.new

      # Write command header
      binary_writer.value = options[:command]
      header_buffer.pos = 0
      binary_writer.write(header_buffer)

      # Write checksum header
      binary_writer.value = options[:checksum]
      header_buffer.pos = 2
      binary_writer.write(header_buffer)

      # Write session ID header
      binary_writer.value = options[:session_id]
      header_buffer.pos = 4
      binary_writer.write(header_buffer)

      # Write reply ID header
      binary_writer.value = options[:reply_id]
      header_buffer.pos = 6
      binary_writer.write(header_buffer)

      # Write command string header
      header_buffer.pos = 8
      header_buffer.write(options[:command_string])

      # Rewrite checksum header
      binary_writer.value = create_checksum({
        data: header_buffer.string
      })
      header_buffer.pos = 2
      binary_writer.write(header_buffer)

      # Rewrite reply ID header
      binary_writer.value = (options[:reply_id] + 1) % USHRT_MAX
      header_buffer.pos = 6
      binary_writer.write(header_buffer)

      header_buffer.string
    end

    # Create checksum for execution
    #
    # param  options
    #        |_ data  Data to create checksum
    def create_checksum(options)
      data = options[:data]
      checksum = 0

      (0...data.length).step(2){ |i|
        checksum += (i == data.length - 1) ? BinData::Uint8le.read(data[i]).snapshot : BinData::Uint16le.read(data[i..-1]).snapshot
        checksum %= USHRT_MAX
      }

      chksum = USHRT_MAX - checksum - 1
      chksum
    end

    # Check validity of response
    #
    # param  options
    #        |_ data  Data to check validity
    def check_valid(options)
      BinData::Uint16le.read(options[:data][0..-1]).snapshot == CMD_ACK_OK
    end

    # Convert time to number of seconds
    #
    # param  options
    #        |_ time  Time object to encode
    def encode_time(options)
      time = options[:time]

      ((time.year % 100) * 12 * 31 + (time.mon * 31) + time.day - 1) * (24 * 60 * 60) + (time.hour * 60 + time.min) * 60 + time.sec
    end

    # Convert number of seconds to time
    #
    # param  options
    #        |_ seconds  Time in seconds to decode
    def decode_time(options)
      time = options[:seconds]

      # Calculate second value
      second = time % 60
      time = (time - second) / 60

      # Calculate minute value
      minute = time % 60
      time = (time - minute) / 60

      # Calculate hour value
      hour = time % 24
      time = (time - hour) / 24

      # Calculate day value
      day = time % 31 + 1
      time = (time - day + 1) / 31

      # Calculate month value
      month = time % 12 + 1
      time = (time - month + 1) / 12

      # Calculate year value
      year = time + 2000

      Time.new(year, month, day, hour, minute, second)
    end

    # Receive data from non-blocking socket
    #
    # param  options
    #        |_ socket  Socket to receive data from
    def receive_nonblock(options)
      return options[:socket].recvfrom_nonblock(65535)
    rescue IO::WaitReadable
      IO.select([options[:socket]])

      retry
    end
  end
end
