require_relative "#{$ROOT}/common/logger/logger"

class Server
  include Common::Logger

  def initialize
    log ({ type: :notice,
           text: 'Initializing database...' })
    action_result = init_database
    log ({ type: (action_result ? :notice : :error),
           text: (action_result ? 'Done' : 'Failed') })
    log ({ type: :notice,
           text: 'Initializing core...' })
    action_result = load_core
    log ({ type: (action_result ? :notice : :error),
           text: (action_result ? 'Done' : 'Failed') })
    log ({ type: :notice,
           text: 'Initializing network...' })
    action_result = init_network
    log ({ type: (action_result ? :notice : :error),
           text: (action_result ? 'Done' : 'Failed') })
  end

  private

  def load_core
    false
  end

  def init_database
    false
  end

  def init_network
    false
  end
end
