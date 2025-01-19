class DiscordBotComponentService
  def self.add_countries(params)
    country = {
      'US' => 'United States',
      'GB' => 'United Kingdom',
      'CA' => 'Canada',
      'FR' => 'France',
      'DK' => 'Denmark',
      'DE' => 'Germany',
      'PL' => 'Poland',
      'SE' => 'Sweden',
      'EE' => 'Estonia',
      'AT' => 'Austria',
      'FI' => 'Finland',
      'IT' => 'Italy',
      'CH' => 'Switzerland',
      'BE' => 'Belgium',
      'NL' => 'Netherlands',
      'ES' => 'Spain',
      'NO' => 'Norway',
      'CZ' => 'Czech Republic',
      'TR' => 'Turkey',
      'AE' => 'United Arab Emirates',
      'NZ' => 'New Zealand',
      'AU' => 'Australia',
      'MX' => 'Mexico',
      'ZA' => 'South Africa'
    }
    options = country.map do |k, v|
      {
        label: v,
        value: k
      }
    end

    payload = {
      content: "Please select country:",
      components: [
        {
          type: 1,
          components: [
            {
                type: 3,
                custom_id: "country_code",
                options: options,
                placeholder: "Choose a country",
                min_values: 1,
                max_values: 3
            }
          ]
        }
      ]
    }
    add_components(payload, params[:channel_id])
    return
  end

  def self.add_keyword(params = {country_code: 'US', keyword: 'Music'})
    payload = {
      content: 'Please select button for input value:',
      components: [
        {
          type: 1,
          components: [
            {
              type: 2,
              label: "Country: #{params[:country_code].join(",")}",
              style: 1,
              custom_id: 'country'
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
    add_components(payload, params[:channel_id])
  end

  def self.add_components(payload, channel_id)
    bot_token = Rails.application.credentials.config[:discord][:token]
    uri       = URI("https://discord.com/api/v10/channels/#{channel_id}/messages")
    http      = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, {
      'Content-Type' => 'application/json',
      'Authorization' => "Bot #{bot_token}"
    })
    request.body = payload.to_json

    # Send the request
    http.request(request)
  end
end