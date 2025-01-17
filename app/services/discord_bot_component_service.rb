class DiscordBotComponentService
  def self.add_keyword
    bot_token = Rails.application.credentials.config[:discord][:token]
    channel_id = 1328014476993368213

    uri = URI("https://discord.com/api/v10/channels/#{channel_id}/messages")

    # Construct the payload
    payload = {
      content: 'Please click keyword button for input keyword:',
      components: [
        {
          type: 1, # Action Row
          components: [
            {
              type: 2, # Button
              label: 'Keyword',
              style: 1, # Primary style
              custom_id: 'keyword'
            }
          ]
        }
      ]
    }
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, {
      'Content-Type' => 'application/json',
      'Authorization' => "Bot #{bot_token}"
    })
    request.body = payload.to_json

    # Send the request
    response = http.request(request)
    return
  end
end