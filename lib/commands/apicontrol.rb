module XBee
  class XBeeCliApp < Thor
    desc 'apicontrol',
      ''
    required_shared_options
    def apicontrol
      xbee = XBee::BaseAPIModeInterface.new(options[:device])

      puts "Testing API now ..."
      puts "====================================================="
      puts "Association Indication: 0x%02x" % xbee.association_indication
      puts "-----------------------------------------------------"
      puts "Firmware Rev: 0x%04x" % xbee.fw_rev
      puts "-----------------------------------------------------"
      puts "Hardware Rev: 0x%04x" % xbee.hw_rev
      puts "-----------------------------------------------------"
      puts "Serial Number High: 0x%08x" % xbee.serial_num_high
      puts "Serial Number Low: 0x%08x" % xbee.serial_num_low
      puts "Serial Number: 0x%016x" % xbee.serial_num
      puts "-----------------------------------------------------"
      puts "Detecting neighbors ..."
      response = xbee.neighbors
      response.each do |r|
        puts "----------------------"
        r.each do |key, val|
          puts case key
          when :NI
            "#{key} = '#{val}'"
          when :STATUS, :DEVICE_TYPE
            "#{key} = 0x%02x" % val
          when :SH, :SL
            "#{key} = 0x%08x" % val
          else "#{key} = 0x%04x" % val
          end
        end
      end
    end
  end
end
