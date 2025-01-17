class DiscordBotComponentService
  def self.add_keyword(params = {countryCode: 'US', state: 'CA', city: nil, keyword: 'Music'})
    bot_token = Rails.application.credentials.config[:discord][:token]
    channel_id = 1328014476993368213

    uri = URI("https://discord.com/api/v10/channels/#{channel_id}/messages")

    # Construct the payload
    payload = {
      content: 'Please select button for input value:',
      components: [
        {
          type: 1,
          components: [
            {
              type: 2,
              label: "Country: #{params[:countryCode]}",
              style: 1,
              custom_id: 'country'
            },
            {
              type: 2,
              label: "State: #{params[:state]}",
              style: 2,
              custom_id: 'state'
            },
            {
              type: 2,
              label: "City: #{params[:city]}",
              style: 2,
              custom_id: 'city'
            },
            {
              type: 2,
              label: "Keyword: #{params[:keyword]}",
              style: 1,
              custom_id: 'keyword'
            },
            {
              type: 2,
              label: 'Search',
              style: 3,
              custom_id: 'search'
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