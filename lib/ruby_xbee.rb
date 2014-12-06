# == Synopsis
# xbee.rb - A Ruby class for manipulating an XBee via the serial communication port of the host
#
# this code is designed for the following XBee modules:
#   IEEE® 802.15.4 OEM RF Modules by Digi International
#   Series 1 XBee and XBee Pro modules
#
# :title: xbee.rb - A Ruby class for manipulating an XBee via the serial communication port of the host
#
# == Copyright
#
# Copyright (C) 2008-2009 360VL, Inc. and Landon Cox
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License version 3 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License version 3 for more details.
#
# You should have received a copy of the GNU Affero General Public License along with this program.
# If not, see http://www.gnu.org/licenses/
#
# You can learn more about Ruby::XBee and other projects at http://sawdust.see-do.org
#
# see Digi product manual: "Product Manual v1.xCx - 802.15.4 Protocol"
# for details on the operation of XBee series 1 modules.

require 'date'
require 'pp'
require 'yaml'

require 'rubygems'
require 'serialport'
require 'require_all'

require_rel 'xbee'

module XBee
  ##
  # supports legacy API, command-mode interface
  def XBee.new( xbee_usbdev_str, baud, data_bits, stop_bits, parity )
    require 'legacy/command_mode'
    BaseCommandModeInterface.new(xbee_usbdev_str, baud, data_bits, stop_bits, parity)
  end

  ##
  # a method for getting results from any Ruby SerialPort object. Not ideal, but seems effective enough.
  def getresults( sp, echo = true )
    results = ""
    while (c = sp.getc) do
      if ( !echo.nil? && echo )
        putc c
      end
      results += "#{c.chr}"
    end

    # deal with multiple lines
    results.gsub!( "\r", "\n")
  end
end  # module XBee

require 'apimode/xbee_api'
