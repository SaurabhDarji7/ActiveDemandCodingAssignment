if defined?(Rails::Server) && Rails.env.development?
  Rails.application.config.after_initialize do
    Rails.logger.info("============Calling ApplicationStateBuilder...")
    ApplicationStateBuilder.new.call
  end
end
