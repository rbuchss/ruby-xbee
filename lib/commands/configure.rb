# == Synopsis
# xbeeconfigure.rb - A utility for configuring an XBee using Ruby and the Ruby::XBee class
#
# :title: xbeeconfigure.rb A utility for configuring an XBee using Ruby and the Ruby::XBee class
#
# == Usage
# === Syntax
#   ./xbeeconfigure.rb [options]
#
# Command line help
#
#   ./xbeeconfigure.rb --help
#    xbeeconfigure.rb [options]
#    Options:
#       [--panid new_pan_id] [-p new_pan_id]      sets the XBee PAN ID
#       [--channel new_channel] [-c new_channel]  sets the new channel number for XBee RF
#       [--mysrc new_address] [-M new_address]    sets MY 16-bit source address (0-0xffff)
#       [--nodeid new_node_id] [-n new_node_id]   sets the text for the XBee node ID
#       [--desthigh highaaddress] [-H highaddress] sets the high portion of the destination address
#       [--destlow low_address] [-L low_address]  sets the low portion of the destination address
#       [--parity [NEOMS]] [-P [NEOMS]]           sets new parity, N = 8bit no-parity, E = 8bit even, O = 8bit odd, M = 8bit mark, S = 8bit space
#       [--newbaud baud_rate] [-B baud_rate]      sets a new baud rate in XBee to take effect after configuration is complete
#       [--dev device] [-d device]                use this device to talk to XBee (ie: /dev/tty.usb-791jdas)
#       [--baud baud_rate] [-b baud_rate]         use this baud rate for configuring the device
#       [--save] [-s]                             write new configuration to XBee flash when finished; default is: configuration is not flashed
#       [--help] print this command help message
#
#
# Example usage
#  ./xbeeconfigure.rb --nodeid BaseStation --panid 01 --mysrc 01 -H0 -L 2 -s
#
# The command above configures an XBee with a human readable node ID of "BaseStation", a PAN ID of 1, sets the device's MY 16-bit source
# address to 1, sets the destination to point to an XBee in a 16-bit addressing mode with a low address of 2 (-L 2) and a high of 0
# which determines this is a 16-bit address.)  Finally, the -s causes the new configuration to be saved in XBee flash when
# the configuration is completed.  The "BaseStation" node id is reported as one of the attributes from neighboring nodes.
#
# Since there are both long and short versions of the same options, an equivalent, shorter command line is:
#   ./xbeeconfigure.rb -n BaseStation -M 01 -M 01 -H0 -L 2 -s
#
# See conf/xbeeconfig.rb for configuration defaults
#
# this code is designed for the following XBee modules:
# IEEE® 802.15.4 OEM RF Modules by Digi International
# Series 1 XBee and XBee Pro modules
#
# == Copyright
# Copyright (C) 2008-2009 360VL, Inc. and Landon Cox
#
# == License
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
# == See Also
# xbeeinfo.rb, xbeeconfigure.rb, xbeedio.rb, xbeelisten.rb, xbeesend.rb
#
# == Learn More
#
# You can learn more about Ruby::XBee and other projects at http://sawdust.see-do.org
#
# see Digi product manual: "Product Manual v1.xCx - 802.15.4 Protocol"
# for details on the operation of XBee series 1 modules.

@xbee_config_version = "xbeeconfig 1.0"

=begin rdoc
  dump usage info to the console
=end
def dump_help

  puts "xbeeconfigure.rb [options]"
  puts "Options:"
  puts "   [--panid new_pan_id] [-p new_pan_id]      sets the XBee PAN ID"                               # set panid
  puts "   [--channel new_channel] [-c new_channel]  sets the new channel number for XBee RF"            # set channel
  puts "   [--mysrc new_address] [-M new_address]    sets MY 16-bit source address (0-0xffff)"
  puts "   [--nodeid new_node_id] [-n new_node_id]   sets the text for the XBee node ID"                 # set nodeid
  puts "   [--desthigh highaddress] [-H highaddress] sets the high portion of the destination address"   # set destination high address
  puts "   [--destlow low_address] [-L low_address]  sets the low portion of the destination address"    # set destination low address
  puts "   [--parity [NEOMS]] [-P [NEOMS]]           sets new parity, N = 8bit no-parity, E = 8bit even, O = 8bit odd, M = 8bit mark, S = 8bit space"
  puts "   [--newbaud baud_rate] [-B baud_rate]      sets a new baud rate in XBee to take effect after configuration is complete"

  puts "   [--dev device] [-d device]                use this device to talk to XBee (ie: /dev/tty.usb-791jdas)"
  puts "   [--baud baud_rate] [-b baud_rate]         use this baud rate for configuring the device"     # override baud
  puts "   [--save] [-s]                             write new configuration to XBee flash when finished; default is: configuration is not flashed"
  puts "   [--help] print this command help message"

  puts "\nSee conf/xbeeconfig.rb for defaults and edit conf/xbeeconfig.rb to change the defaults used to communicate with the device"
  puts "\nCopyright (C) 2008-2009 360VL, Inc and Landon Cox"
  puts "\nThis program comes with ABSOLUTELY NO WARRANTY;"
  puts "This is free software, and you are welcome to redistribute it"
  puts "under certain conditions detailed in: GNU Affero General Public License version 3"

end

module XBee
  class XBeeCliApp < Thor
    desc 'configure [-b <baud_rate>]',
      ''
    shared_options
    method_option :panid, aliases: '-p', required: true    # set panid
    method_option :nodeid, aliases: '-n', required: true   # set nodeid
    method_option :desthigh, aliases: '-H', required: true # set destination high address
    method_option :destlow, aliases: '-L', required: true  # set destination low address
    method_option :channel, aliases: '-c', required: true  # set channel
    method_option :parity, aliases: '-P', required: true   # set parity
    # TODO remove
    method_option :newbaud, aliases: '-B', required: true  # set new baud rate in XBee, will not take effect until exiting command mode or AT command mode timeout
    method_option :mysrc, aliases: '-M', required: true    # set nodeid
    method_option :save, aliases: '-s' # GetoptLong::NO_ARGUMENT ]           # write new configuration to XBee flash when finished
    def configure
      # start the configuration
      xbee = XBee.new(options[:device], options[:baud_rate],
                      options[:data_bits], options[:stop_bits],
                      options[:parity])

      # before doing anything else, put XBee into AT command mode
      puts "Attention..."
      if !xbee.attention.match("OK")
        puts "Can't talk to XBee.  Please check your connection or configuration: #{res}"
        exit 1
      end

      # execute configuration
      if options[:panid]
        puts "Setting PAN ID"
        xbee.pan_id!(options[:panid])
        puts "PAN id: #{xbee.pan_id}"
      end

      if options[:mysrc]
        puts "Setting MY 16-bit source address"
        xbee.my_src_address!(options[:mysrc].upcase)
      end

      if options[:nodeid]
        puts "Setting Node ID"
        xbee.node_id!(options[:nodeid])
      end

      if options[:desthigh] && options[:destlow]
        puts "Setting destination address"
        xbee.destination_high!(options[:desthigh])
        xbee.destination_low!(options[:destlow])
      end

      if options[:channel]
        puts "Setting channel"
        xbee.channel!(options[:channel])
        puts "Channel: #{xbee.channel}"
      end

      if options[:baud_rate]
        puts "Setting new baud rate"
        xbee.baud!(options[:baud_rate])
      end

      if options[:newparity]
        puts "Setting new parity"
        xbee.parity!(options[:newparity].upcase.to_sym)
      end

      if options[:save]
        puts "Saving configuration to XBee flash"
        xbee.save!
      end

      puts "Exiting AT command mode"
      xbee.exit_command_mode
    end
  end
end
