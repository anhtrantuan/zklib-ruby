$: << './lib'

require 'zklib'

@client = nil

def connect
  # Usage: ruby test/debug.rb 192.168.12.34
  @client = Zklib.new(
    ip:     ARGV[0],
    port:   4370,
    inport: 5200,
  )

  @client.connect
  puts 'Connected!'
end

def disconnect
  @client.disconnect
  @client = nil
  puts 'Disconnected!'
end

connect

# Serial management
puts
puts "Serial number: #{@client.get_serial_number}"

# Version management
puts
puts "OS version: #{@client.get_os_version}"
puts "Firmware version: #{@client.get_firmware_version}"
puts "Platform version: #{@client.get_platform_version}"

# Platform management
puts
puts "Platform: #{@client.get_platform}"

# SSR management
puts
puts "SSR: #{@client.get_ssr}"

# PIN management
puts
puts "PIN width: #{@client.get_pin_width}"

# Work Code management
puts
puts "Work code: #{@client.get_work_code}"

# Time management
puts
puts "Current time: #{@client.get_time}"
# time = Time.now
# puts "Set time to: #{time}" if @client.set_time(time)

# Attendance management
puts
attendances = @client.get_attendances
puts "Attendance count: #{@client.get_attendance_count / Zklib::ATTENDANCE_DATA_SIZE}"
if attendances.any?
  puts 'Attendances:'
  attendances.each.with_index(1) do |attendance, index|
    puts " - ##{index}"
    puts "   + UID: #{attendance[:uid]}"
    puts "   + ID: #{attendance[:id]}"
    puts "   + State: #{(attendance[:state] == 0) ? 'Password' : 'Fingerprint'}"
    puts "   + Timestamp: #{attendance[:timestamp]}"
  end
end
# disconnect
# connect
# @client.clear_attendances
# puts 'Cleared attendances!'

# User management
puts
sleep 0.5
connect
user_uid      = 100
user_user_id  = '0000001'
user_name     = 'Cao Hoai Viet'
user_password = '1234'
user_role     = Zklib::LEVEL_ADMIN
@client.create_user(uid: user_uid, user_id: user_user_id, name: user_name, password: user_password, role: user_role)
puts "Set user with uid=#{user_uid}, user_id=#{user_user_id}, name=#{user_name}, password=#{user_password}, role=#{user_role}"
users = @client.get_users
puts "User count: #{@client.get_user_count / Zklib::USER_DATA_SIZE}"
if users.any?
  puts 'Users:'
  users.each.with_index do |user, index|
    puts " - ##{index}"
    puts "   + UID: #{user[:uid]}"
    puts "   + Card No: #{user[:card_no]}"
    puts "   + Role: #{(user[:role] == 0) ? 'User' : 'Admin'}"
    puts "   + Password: #{user[:password]}"
    puts "   + Name: #{user[:name]}"
    puts "   + User ID: #{user[:user_id]}"
  end
end
sleep 0.5
connect
@client.delete_user(uid: user_uid)
puts "Deleted user with uid=#{user_uid}"
users = @client.get_users
puts "User count: #{@client.get_user_count / Zklib::USER_DATA_SIZE}"
if users.any?
  puts 'Users:'
  users.each.with_index do |user, index|
    puts " - ##{index}"
    puts "   + UID: #{user[:uid]}"
    puts "   + Card No: #{user[:card_no]}"
    puts "   + Role: #{(user[:role] == 0) ? 'User' : 'Admin'}"
    puts "   + Password: #{user[:password]}"
    puts "   + Name: #{user[:name]}"
    puts "   + User ID: #{user[:user_id]}"
  end
end
# disconnect
# connect
# @client.clear_users
# puts 'Cleared users!'
# disconnect
# connect
# @client.clear_admins
# puts 'Cleared admins!'

# Device management
sleep 0.5
puts
connect
puts "Device name: #{@client.get_device_name}"
# @client.restart_device
# puts 'Restarted!'
# @client.power_off_device
# puts 'Turned off!'
sleep 0.5
connect
@client.disable_device
puts 'Disabled for 3 seconds!'
sleep 3
connect
@client.enable_device
puts 'Enabled!'

# Face management
sleep 0.5
puts
connect
@client.turn_face_on
puts 'Turned face on for 3 seconds!'
sleep 3
connect
@client.turn_face_off
puts 'Turned face off!'

# Data management
puts
@client.refresh_data
puts 'Refreshed data for transmission!'
@client.free_data
puts 'Freed data for transmission!'

puts
disconnect
