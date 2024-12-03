if defined?(Prosopite)
  Rails.application.config.to_prepare do
    Prosopite.rails_logger = true      # Log to Rails logger
    Prosopite.prosopite_logger = true  # Log to separate prosopite.log

    # # Configure path for logs
    # Prosopite.log_path = Rails.root.join('log', 'prosopite.log')
    #
    # # Ignore certain paths
    # Prosopite.ignore_paths = [
    #   'vendor/',
    #   'lib/tasks/'
    # ]
  end
end
