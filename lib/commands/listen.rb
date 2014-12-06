# == Synposis
# xbeelisten.rb - A ruby utility for listening to data output from an XBee
#
# :title: xbeelisten.rb - A ruby utility for listening to data output from an XBee
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
# You can learn more about ruby for XBee and other projects at http://sawdust.see-do.org
#
# == Usage
#    ./xbeelisten.rb
#
# Example output from xbeelisten...this example is an XBee listening to
# a Sparkfun USB Weather board which is transmitting data through a 2nd
# XBee:
#    cooper:ruby-xbee lcox$ ./xbeelisten.rb
#    #10.75,069.47,020.9,069.62,079038,612,050580$
#    #10.22,070.46,021.5,070.70,078998,613,052232$
#    #10.22,070.44,021.6,070.88,078993,613,052233$
#
# See conf/xbeeconfig.rb for configuration defaults
#
# == See Also
# xbeeinfo.rb, xbeeconfigure.rb, xbeedio.rb, xbeelisten.rb, xbeesend.rb
#
# == Learn more
# You can learn more about Ruby::XBee and other projects at http://sawdust.see-do.org
#
# see Digi product manual: "Product Manual v1.xCx - 802.15.4 Protocol"
# for details on the operation of XBee series 1 modules.
#
# this code is for the following XBee modules:
# IEEE® 802.15.4 OEM RF Modules by Digi International
#

module XBee
  class XBeeCliApp < Thor
    desc 'listen [-b <baud_rate>]',
      ''
    shared_options
    def listen
      # start a connection to the XBee
      xbee = XBee.new(options[:device], options[:baud_rate],
                      options[:data_bits], options[:stop_bits],
                      options[:parity])

      # read XBee output forever
      while(true)
        xbee.getresponse true
      end
    end
  end
end
