namespace :feed do
  desc "Download and process the feed file"
  task process: :environment do
    UserOption.where(monitor: true).each do |option|
    end    
  end
end