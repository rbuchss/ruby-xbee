# == Synopsis
# xbeedio.rb - A Ruby utility for reading DIO port configuration and sample data
#
# :title:  A Ruby utility for configuring and manipulating XBee DIO ports
# == Usage
#  xbeedio.rb
#
# See conf/xbeeconfig.rb for configuration defaults
#
# Example output from xbeedio.rb
#   $ ./xbeedio.rb
#    Attention: OK
#    Port 0: Disabled
#    Port 1: DI
#    Port 2: Disabled
#    Port 3: Disabled
#    Port 4: Disabled
#    Port 5: Associated_Indicator
#    Port 6: Disabled
#    Port 7: CTS
#    Port 8: Disabled
#    DIO inputs:
#    Number of Samples: 1
#    Channel mask: 002
#    DIO data: 002
#
# this code is designed for the following XBee modules:
# IEEE® 802.15.4 OEM RF Modules by Digi International
# Series 1 XBee and XBee Pro modules
#
# == Copyright
#
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

# == Learn More
# You can learn more about Ruby::XBee and other projects at http://sawdust.see-do.org
#
# see Digi product manual: "Product Manual v1.xCx - 802.15.4 Protocol"
# for details on the operation of XBee series 1 modules.

module XBee
  class XBeeCliApp < Thor
    desc 'dio [-b <baud_rate>] [--data-bits] [--stop-bits] [--parity]',
      'utility for configuring and manipulating XBee DIO ports'
    shared_options
    def dio
      # start a connection to the XBee
      device = options[:device] || USB.prompt_for_device
      xbee = XBee.new(device, options[:baud_rate],
                      options[:data_bits], options[:stop_bits],
                      options[:parity])

      logger.info "Attention: #{xbee.attention}"

      0.upto(8) do |num|
        portsym = "D#{num}".to_sym
        logger.info "Port #{num}: #{xbee.dio(portsym)}"
      end

      logger.info "DIO inputs:"
      results = xbee.io_input
      if results and results[:ERROR].nil?
        logger.info "Number of Samples: #{results[:NUM]}" \
        "Channel mask: #{results[:CM]}" \
        "DIO data: #{results[:DIO]}"

        # up to 6 lines (ADC0-ADC5) of ADC could be present if all enabled
        0.upto(5) do |adc_channel|
          adcsym = "ADC#{adc_channel}".to_sym
          if results[adcsym]
            logger.info "ADC#{adc_channel} data: #{results[adcsym]}"
          end
        end
      else
        logger.info "No DIO input data to report"
      end
    end
  end
end
