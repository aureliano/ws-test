module Model

  class WsConfig
  
    def initialize
      yield self if block_given?
    end
    
    attr_accessor :env_namespace, :namespaces, :ssl_verify_mode, :ssl_version,
                  :ssl_cert_file, :ssl_cert_key_file, :ssl_ca_cert_file, :ssl_cert_key_password
      
    def self.load_ws_config
      data = YAML.load_file ENV['ws.config.path']
      profile = ((ENV['profile'] == 'default' || ENV['profile'].nil?) ? '' : "#{ENV['profile']}.")

      WsConfig.new do |c|
        c.env_namespace = data['request.env.namespace']
        c.namespaces = data['request.namespaces']
        c.ssl_verify_mode = data["#{profile}ssl.verify.mode"].to_sym if data["#{profile}ssl.verify.mode"]
        c.ssl_version = data["#{profile}ssl.version"].to_sym if data["#{profile}ssl.version"]
        c.ssl_cert_file = data["#{profile}ssl.cert.file"]
        c.ssl_cert_key_file = data["#{profile}ssl.cert.key.file"]
        c.ssl_ca_cert_file = data["#{profile}ssl.ca.cert.file"]
        c.ssl_cert_key_password = data["#{profile}ssl.cert.key.password"]
      end
    end
  
  end

end
