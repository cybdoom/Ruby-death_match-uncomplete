module Deathmatch
  module Common
    module Logger
      def log message
        @log_history ||= []
        @log_history.unshift message
        puts "[ death_match_server ]->[ #{self.class} ] #{message[:type].to_s.upcase}: #{message[:text]}"
      end

      def log_history
        @log_history
      end
    end
  end
end
