class Zklib
  module UserManagement
    # Clear admins
    def clear_admins
      execute_cmd(
        command:        CMD_CLEAR_ADMIN,
        command_string: ''
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 7
          data.split("\u0000").pop
        else
          puts 'ERROR: Invalid clear admins response'
        end
      end
    end

    # Clear users
    def clear_users
      execute_cmd(
        command:        CMD_CLEAR_DATA,
        command_string: ''
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 7
          data.split("\u0000").pop
        else
          puts 'ERROR: Invalid clear users response'
        end
      end
    end

    # Create user
    # param  options
    #        |_ uid       UID
    #        |_ user_id   User ID
    #        |_ name      Name
    #        |_ password  Password
    #        |_ role      Role
    def create_user(options)
      # command_string  = (options[:uid] % 256).chr
      # command_string += (options[:uid] >> 8).chr
      command_string  = options[:uid].chr.ljust(2, 0.chr)
      command_string += options[:role].chr
      command_string += options[:password].ljust(8, 0.chr)
      command_string += options[:name].ljust(28, 0.chr)
      command_string += 1.chr
      command_string += 0.chr * 8
      command_string += options[:user_id].ljust(8, 0.chr)
      command_string += 0.chr * 16

      execute_cmd(
        command:        CMD_SET_USER,
        command_string: command_string
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 7
          data.split("\u0000").pop
        else
          puts 'ERROR: Invalid set user response'
        end
      end
    end

    # Decode user data
    # param  options
    #        |_ data  User data to decode
    def decode_user_data(options)
      data = options[:data]

      {
        uid:      BinData::Uint16be.read(data[0..1]).snapshot,
        role:     BinData::Uint16be.read(data[2..3]).snapshot,
        password: data[4..11].split("\0").pop,
        name:     data[12..35].split("\0").pop,
        card_no:  BinData::Uint32le.read(data[36..39]).snapshot,
        user_id:  data[49..71].split("\0").pop
      }
    end

    # Delete user
    # param  options
    #        |_ uid  UID
    def delete_user(options)
      command_buffer = StringIO.new
      binary_writer  = BinData::Uint16le.new

      binary_writer.value = options[:uid]
      command_buffer.pos  = 0
      binary_writer.write(command_buffer)

      command_string = command_buffer.string

      execute_cmd(
        command:        CMD_DELETE_USER,
        command_string: command_string
      ) do |opts|
        return puts "ERROR: #{options[:error]}" unless opts[:valid]

        data = opts[:data]
        if data.length > 7
          data.split("\u0000").pop
        else
          puts 'ERROR: Invalid clear admins response'
        end
      end
    end

    # Get user list size
    def get_user_count
      return 0 if BinData::Uint16le.read(data_recv).snapshot != CMD_PREPARE_DATA

      BinData::Uint32le.read(data_recv[8..-1]).snapshot
    end

    # Get users
    def get_users
      header = create_header(
        command:        CMD_USERTEMP_RRQ,
        command_string: 5.chr,
        checksum:       0,
        session_id:     session_id,
        reply_id:       BinData::Uint16le.read(data_recv[6..-1]).snapshot
      )

      # Send command
      socket = UDPSocket.new
      socket.bind('0.0.0.0', inport)
      socket.send(header, 0, ip, port)

      ### START Get response size ###
      self.data_recv = receive_nonblock(socket: socket)[0]

      return puts 'ERROR: Empty response' unless data_recv && data_recv.length > 0

      self.session_id = BinData::Uint16le.read(data_recv[4..-1]).snapshot
      total_bytes     = get_user_count

      # Stop if user list is empty
      if total_bytes <= 0
        socket.close

        return []
      end
      ### END Get response size ###

      ### START Get user list ###
      bytes_recv     = 0
      rem            = nil
      offset         = 0
      user_data_size = 72
      trim_first     = 11
      trim_others    = 8
      users          = []

      while true
        data = receive_nonblock(socket: socket)[0]

        if bytes_recv == 0
          offset     = trim_first
          bytes_recv = 4
        else
          offset = trim_others
        end

        while(data.length - offset >= user_data_size)
          user_data  = data[offset..-1]
          offset    += user_data_size

          if rem && rem.length > 0
            user_data.prepend(rem)
            offset -= rem.length
            rem     = nil
          end

          users << decode_user_data(data: user_data)
          bytes_recv += user_data_size

          if bytes_recv == total_bytes
            socket.close

            return users
          end
        end

        rem = data[offset..-1]
      end
      ### END Get user list ###

      socket.close
    end
  end
end
