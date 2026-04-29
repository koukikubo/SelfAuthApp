# app/services/base_service.rb
class BaseService
  def self.call(...)
    new(...).call
  end

  private

  def with_transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end

  def log_info(message)
    Rails.logger.info("[#{self.class.name}] #{message}")
  end

  def log_error(message)
    Rails.logger.error("[#{self.class.name}] #{message}")
  end
end