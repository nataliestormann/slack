class SlackCommand
  attr_reader :request
  private :request

  def initialize(slack_request)
    @request = slack_request
  end

  def run
    command_class.new(request).run
  end

  private

  def command
    request.command.to_sym
  end

  def command_class
    command_classes[command] || NullSlackCommand
  end

  def command_classes
    {
        tarot: SlackTarot
    }
  end
end

class NullSlackCommand
  def initialize(slack_request)
  end

  def run
    {
        text: 'Command not available'
    }
  end
end
