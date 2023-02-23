namespace :line_notice do
  desc '定期的にissが見える時間を通知する'
  task iss_lookup_time: :environment do
    client ||= Line::Bot::Client.new do |config|
      config.channel_secret = Rails.application.credentials[:LINE_CHANNEL_SECRET]
      config.channel_token = Rails.application.credentials[:LINE_CHANNEL_TOKEN]
    end

    uri = URI.parse('https://lookup.kibo.space/json/area/tokyo.json')
    response = Net::HTTP.get_response(uri)
    result = JSON.parse(response.body)
    result['contents'].each do |i|
      next unless Time.zone.yesterday == i['data']['begin']['data']['date'].to_date

      time = i['data']['begin']['time']
      Time.at(time / 1000.0).strftime('%Y/%m/%d %H:%M:%S')
      message = { type: 'text', text: "#{start}に見え始めるよ" }
      client.broadcast(message)
    end
  end
end
