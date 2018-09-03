# Info taken from here:
# https://api.slack.com/docs/verifying-requests-from-slack
#
# The SlackRequest class is responsible for authenticating the request from Slack

class SlackRequest
  attr_reader :request
  private :request

  def initialize(request)
    @request = request
  end

  def valid?
    request_signature == generated_signature
  end

  def command
    @command ||= parsed_body['text'].split(' ').first
  end

  private

  def parsed_body
    @parsed_body ||= Rack::Utils.parse_nested_query(request_body)
  end

  def request_signature
    request.env['HTTP_X_SLACK_SIGNATURE']
  end

  def request_timestamp
    request.env['HTTP_X_SLACK_REQUEST_TIMESTAMP']
  end

  def slack_signing_secret
    ENV['SLACK_SIGNING_SECRET']
  end

  # Reference: https://api.slack.com/docs/verifying-requests-from-slack
  def generated_signature
    OpenSSL::HMAC.hexdigest(
        'SHA256',
        slack_signing_secret,
        request_string
    ).prepend('v0=')
  end

  def request_string
    [
        'v0',
        request_timestamp,
        request_body
    ].join(':')
  end

  # Using read/rewind here as Rack will flush body once read
  # Using Ruby tap to rewind, and return original read
  def request_body
    request.body.read.tap do
      request.body.rewind
    end
  end
end
