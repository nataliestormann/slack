require 'sinatra'
require 'sinatra/json'
require 'openssl'
require './lib/all'

post '/slack/command' do
  req = SlackRequest.new(request)

  # Making sure it is from Slack!
  if req.valid?
    response = SlackCommand.new(req).run
    json response
  else
    status 401
  end
end
