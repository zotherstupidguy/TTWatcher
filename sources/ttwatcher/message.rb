# encoding: utf-8

module TTWatcher
  #
  # Simply +logger+ based on logger from core lib
  #
  class CustomizedLogger
    extend  Forwardable
    include Singleton

    def_delegator :@logger, :add, :add

    def initialize
      @logger = Logger.new "#{path_to_logs}/log.txt", 10
      @logger.formatter = proc do |severity, datetime, program_name, msg|
        "[#{severity.upcase}! #{datetime.strftime "%H-%M-%S"}] #{msg}\n"
      end
      @logger
    end

    private

    def path_to_logs
      path = File.join(__dir__, '..', '..', 'logs')
      Dir.mkdir path unless Dir.exist? path
      path
    end
  end # class Watcher::CustomizedLogger

  # ----------------------------------------------------

  #
  # Send [INFO] message to logger
  #
  class Message
    class << self
      def self.send(text)
        logger.add Logger::INFO, text
      end

      private

      def logger
        CustomizedLogger.instance
      end
    end # class << self
  end # class TTWatcher::Message

  # ----------------------------------------------------

  #
  # Send [WARN] message to logger
  #
  class MessageWarn < Message
    def self.send(text)
      logger.add Logger::WARN, text
    end
  end # class TTWatcher::MessageWarn

  # ----------------------------------------------------

  #
  # Send [Error] message to logger
  #
  class MessageError < Message
    def self.send(text)
      logger.add Logger::ERROR, text
    end
  end # class TTWatcher::MessageError
end # module TTWatcher
