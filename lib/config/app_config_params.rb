module Theotokos
  module Configuration

    class AppConfigParams
    
      def self.load_app_config_params
        params = _get_config_hash
        ENV['ws.config.path'] = params['ws.config.path'] ||= 'resources/config/ws-config.yml'
        ENV['ws.test.models.path'] = params['ws.test.models.path'] ||= 'resources/ws-test-models'
        ENV['ws.test.output.files.path'] = params['ws.test.output.files.path'] ||= 'resources/outputs'
        ENV['ws.test.reports.locales.path'] = params['ws.test.reports.locales.path'] ||= 'resources/locales'
        ENV['ws.test.reports.locale'] = params['ws.test.reports.locale'] ||= 'en'
        ENV['ws.test.reports.path'] = params['ws.test.reports.path'] ||= 'tmp/reports'
        ENV['logger.stdout.level'] = params['logger.stdout.level'] ||= 'info'
        ENV['logger.stdout.layout.pattern'] = params['logger.stdout.layout.pattern'] ||= '[%d] %-5l -- %c : %m\n'
        ENV['logger.stdout.layout.date_pattern'] = params['logger.stdout.layout.date_pattern'] ||= '%Y-%m-%d %H:%M:%S'
        ENV['logger.rolling_file.level'] = params['logger.rolling_file.level']
        ENV['logger.rolling_file.file'] = params['logger.rolling_file.file']
        ENV['logger.rolling_file.file.append_date'] = params['logger.rolling_file.file.append_date'].to_s
        ENV['logger.rolling_file.pattern'] = params['logger.rolling_file.pattern']
        ENV['logger.rolling_file.date_pattern'] = params['logger.rolling_file.date_pattern']
        ENV['app.config.params.loaded'] = 'true'
      end
      
      def self.rolling_file_logger_defined?
        !(ENV['logger.rolling_file.level'].nil? && ENV['logger.rolling_file.file'].nil?)
      end
      
      def self._get_config_hash
        if ENV['ENVIRONMENT'] == 'test'
          ((ENV['app.cfg.path']) ? YAML.load_file(ENV['app.cfg.path']) : {})        
        else
          ((File.exist? 'app-cfg.yml') ? YAML.load_file('app-cfg.yml') : {})
        end
      end
    
    end

  end
end
