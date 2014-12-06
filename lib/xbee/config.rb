module XBee
  module Config
    DEFAULT = YAML.load_file(File.expand_path('../../config/xbee.yml', File.dirname(__FILE__)))

    def find_key(key, hash)
      hash[key.to_s] or hash[key.to_sym]
    end

    def config_default(param)
      XBeeUARTConfig.default(param) or RFModuleParameter.default(param)
    end

    ##
    # A class for encapsulating UART communication parameters
    class XBeeUARTConfig
      include Config
      extend Config
      attr_accessor :baud, :data_bits, :parity, :stop_bits

      ##
      # Defaults to standard 9600 baud 8N1 communications
      def initialize(options={})
        self.baud = Integer(options[:baud_rate] || default(:baud_rate))
        self.data_bits = Integer(options[:data_bits] || default(:data_bits))
        self.parity = Integer(options[:parity] || default(:parity))
        self.stop_bits = Integer(options[:stop_bits] || default(:stop_bits))
      end

      def self.defaults
        find_key(:XBeeUARTConfig, DEFAULT)
      end

      def self.default(param)
        find_key(param, defaults)
      end

      def default(param)
        self.class.default(param)
      end
    end

    ##
    # A class for encapsulating XBee programmable parameters
    class RFModuleParameter
      include Config
      extend Config
      attr_reader :name, :at_name, :default_value
      attr_accessor :value, :retrieved, :operation_mode

      def initialize(name, options={})
        @name = name
        raise unless defaults
        @at_name = default(:at_name)
        @default_value = default(:default_value)
        self.value = default_value
        self.retrieved = false
      end

      def self.defaults
        find_key(:RFModuleParameter, DEFAULT)
      end

      def defaults
        find_key(@name, self.class.defaults)
      end

      def default(param)
        find_key(param, defaults)
      end

      def in_seconds
        return 'no seconds unit set' unless default(:second_units)
        value / default(:second_units)
      end
    end
  end
end
