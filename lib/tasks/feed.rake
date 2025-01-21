namespace :feed do
  desc "Download and process the feed file"
  task download_and_process: :environment do
    require 'open-uri'
    require 'zlib'
    require 'net/http'
    require 'uri'
    require 'json'
    require 'csv'
    
    api_key   = Rails.application.credentials.config[:ticket][:key]
    url       = "https://app.ticketmaster.com/discovery-feed/v2/events?apikey=#{api_key}"
    uri       = URI.parse(url)
    feed_data = []
    response  = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      feed_data = JSON.parse(response.body)
    else
      puts "Request failed with status: #{response.code} #{response.message}"
      return
    end

    return unless feed_data.present?

    countries = feed_data['countries'].keys
    feed_urls = countries.map{|country| feed_data['countries'][country]['CSV']}
    columns = TicketEvent.column_names.dup
    columns.delete('primary_event_url')
    feed_urls.each do |feed_url|
      compressed_file = 'tmp/events_raw.csv.gz'
      decompressed_file = 'tmp/events_raw.csv'
      uri = feed_url['uri']
      
      next if feed_url['country_code'] != 'US'
      puts "=======processing #{feed_url['country_code']}=============="
      
      File.open(compressed_file, 'wb') do |file|
        file.write(URI.open(uri).read)
      end

      # Decompress the file
      Zlib::GzipReader.open(compressed_file) do |gzip_file|
        File.open(decompressed_file, 'w') do |file|
          file.write(gzip_file.read)
        end
      end

      feed_data = []
      CSV.foreach(decompressed_file, headers: true) do |row|
        feed_data << row.to_h.transform_keys(&:downcase)
        unique_data = feed_data.uniq { |item| item[:primary_event_url] }
        if feed_data.count == 50
          TicketEvent.upsert_all(unique_data, unique_by: :primary_event_url, update_only: columns)
          feed_data = []
        end
      end
      unique_data = feed_data.uniq { |item| item[:primary_event_url] }
      TicketEvent.upsert_all(unique_data, unique_by: :primary_event_url, update_only: columns)
    end
    UserOption.where(monitor: true).each do |option|
      DiscordBotService.send_event_message(option)
      option.update(sent_at: Time.zone.now)
    end
    puts "Feed file downloaded and processed at #{Time.now}"
  end
end