if Rails.env.production? || Rails.env.staging?
  uri = ENV['REDIS_URL'] || 'redis://localhost:6379/'

  Sidekiq.configure_server do |config|
    config.redis = { url: uri }

    database_url = ENV['DATABASE_URL']

    if database_url
      ENV['DATABASE_URL'] = "#{database_url}?pool=25"
      ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
    end
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: uri }
  end
end

if Rails.env.development?
  Sidekiq.configure_server do |config|
    config.redis = {
      host: ENV['REDIS_HOST'],
      port: ENV['REDIS_PORT'] || '6379'
    }
  end
  
  Sidekiq.configure_client do |config|
    config.redis = {
      host: ENV['REDIS_HOST'],
      port: ENV['REDIS_PORT'] || '6379'
    }
  end
end