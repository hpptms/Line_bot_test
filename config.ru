require 'bundler/setup'
require 'sinatra/base'
require 'json'
require 'rest-client'

class App < Sinatra::Base
  post '/linebot/callback' do
    params = JSON.parse(request.body.read)

    params['result'].each do |msg|
      request_content = {
        to: [msg['content']['from']],
        toChannel: 1383378250, # Fixed  value
        eventType: "138311608800106203", # Fixed value
        content: msg['content']
      }

      endpoint_uri = 'https://trialbot-api.line.me/v1/events'
      content_json = request_content.to_json

      RestClient.proxy = ENV["FIXIE_URL"]
      RestClient.post(endpoint_uri, content_json, {
        'Content-Type' => 'application/json; charset=UTF-8',
        'X-Line-ChannelID' => ENV["1462546557"],
        'X-Line-ChannelSecret' => ENV["bcf5d84a55322410d56e5105554a2d08"],
        'X-Line-Trusted-User-With-ACL' => ENV["u7ef6299df0c7632dc34cd6b5e8e319f7"],
      })
    end

    "OK"
  end
end

run App