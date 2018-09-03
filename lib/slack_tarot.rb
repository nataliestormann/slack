# The SlackTarot class will go to TAROT_API_URL and fetch a random tarot card

require 'net/http'
require 'json'

class SlackTarot
  attr_reader :request
  private :request

  TAROT_API_URL = URI('https://rws-cards-api.herokuapp.com/api/v1/cards/random?n=1')

  def initialize(slack_request)
    @request = slack_request
  end

  def run
    {
        text: "*#{card_name}*: #{card_meaning}"
    }
  end

  private

  def card
    tarot_response['cards'].first
  end

  def card_name
    card['name']
  end

  def card_meaning
    card['meaning_up']
  end

  def tarot_response
    @tarot_response ||= JSON.parse(
        Net::HTTP.get(TAROT_API_URL)
    )
  end
end
