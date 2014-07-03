module Model
      
  class TestSuite
  
    def initialize(opt = {})
      if block_given?
        yield self
      else
        _load_properties opt
      end
    end
    
    attr_accessor :source, :wsdl, :service, :tags, :tests
    
    def validate_model!
      raise Exception, 'WS test model must be provided.' if @source.nil? || @source.empty?
      raise Exception, "WSDL's URL must be provided." if @wsdl.nil? || @wsdl.empty?
      raise Exception, 'Service name (service to be tested) must be provided.' if @service.nil? || @service.empty?
    end
    
    private
    def _load_properties(opt)
      self.source = opt[:source]
      self.wsdl = opt[:wsdl]
      self.service = opt[:service]
      
      self.tags = if opt[:tags].instance_of? String
        opt[:tags].split(/[,\s]/).select {|t| !t.empty? }
      elsif opt[:tags].instance_of? Array
        opt[:tags]
      else
        []
      end
    end
  
  end
  
end
