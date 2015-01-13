require 'highline/import'

module XBee
  class USB
    def self.prompt_for_device
      choose do |menu|
        menu.prompt = "Please choose usb device to use?"
        menu.choices(*devices) { |selected| selected }
      end
    end

    def self.devices
      Dir['/dev/tty.usb*']
    end
  end
end
