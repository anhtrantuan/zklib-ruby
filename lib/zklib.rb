require 'zklib/version'

# Libraries
require 'socket'
require 'bindata'

# Mixins
require 'zklib/helper'
require 'zklib/attendance_management'
require 'zklib/connection_management'
require 'zklib/data_management'
require 'zklib/device_management'
require 'zklib/face_management'
require 'zklib/pin_management'
require 'zklib/platform_management'
require 'zklib/serial_management'
require 'zklib/ssr_management'
require 'zklib/time_management'
require 'zklib/user_management'
require 'zklib/version_management'
require 'zklib/work_code_management'

class Zklib
  include Helper
  include AttendanceManagement
  include ConnectionManagement
  include DataManagement
  include DeviceManagement
  include FaceManagement
  include PINManagement
  include PlatformManagement
  include SerialManagement
  include SSRManagement
  include TimeManagement
  include UserManagement
  include VersionManagement
  include WorkCodeManagement

  # Max unsigned short value
  USHRT_MAX = 65535


  # Data structures' size
  ATTENDANCE_DATA_SIZE = 40
  USER_DATA_SIZE       = 72


  # Commands
  CMD_CONNECT       = 1000
  CMD_EXIT          = 1001
  CMD_ENABLEDEVICE  = 1002
  CMD_DISABLEDEVICE = 1003
  CMD_RESTART       = 1004
  CMD_POWEROFF      = 1005

  CMD_ACK_OK        = 2000
  CMD_ACK_ERROR     = 2001
  CMD_ACK_DATA      = 2002

  CMD_PREPARE_DATA  = 1500
  CMD_DATA          = 1501
  CMD_FREE_DATA     = 1502
  CMD_REFRESHDATA   = 1013
  CMD_REFRESHOPTION = 1014

  CMD_USERTEMP_RRQ  = 9
  CMD_ATTLOG_RRQ    = 13
  CMD_CLEAR_DATA    = 14
  CMD_CLEAR_ATTLOG  = 15
  
  CMD_WRITE_LCD     = 66

  CMD_GET_TIME      = 201
  CMD_SET_TIME      = 202

  CMD_VERSION       = 1100
  CMD_DEVICE        = 11

  CMD_CLEAR_ADMIN   = 20
  CMD_DELETE_USER   = 18
  CMD_SET_USER      = 8


  # User levels
  LEVEL_USER  = 0
  LEVEL_ADMIN = 14


  # Login states
  LOGIN_BY_PASSWORD    = 0
  LOGIN_BY_FINGERPRINT = 1


  # Communication states
  STATE_FIRST_PACKET = 1
  STATE_PACKET       = 2
  STATE_FINISHED     = 3


  attr_reader :inport,
              :ip,
              :port
  attr_accessor :data_recv,
                :reply_id,
                :session_id,
                :socket,
                :exttrynumber,
                :id_com


  # param  options  Init options
  #        |_ ip      Attendance machine IP
  #        |_ port    Attendance machine UDP port
  #        |_ inport  Client UDP port
  def initialize(options)
    @ip         = options[:ip]
    @port       = options[:port]
    @inport     = options[:inport]
    @socket     = nil
    @reply_id   = USHRT_MAX - 1
    @data_recv  = ''
    @session_id = 0
  end
end
