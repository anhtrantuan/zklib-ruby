$: << './lib'

require 'zklib'

client = Zklib.new(
  ip:     ARGV[0],
  port:   4370,
  inport: 5200,
)

client.connect
puts 'Connected!'

puts "Serial Number: #{client.get_serial_number}"
puts "Version: #{client.get_version}"
puts "Current Time: #{client.get_time}"
time = Time.now
puts "Set time to: #{time}" if client.set_time(time)

# client.disconnect
# puts 'Disonnected!'
