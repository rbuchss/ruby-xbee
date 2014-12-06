module XBee
  class XBeeCliApp < Thor
    desc 'apilisten',
      ''
    required_shared_options
    def apilisten
      uart_config = XBee::Config::XBeeUARTConfig.new()
      xbee = XBee::BaseAPIModeInterface.new(options[:device], uart_config, 'API')

      # read XBee output forever
      while true
        xbee.getresponse true
      end
    end
  end
end
