module Engine

  class Executor
    
    attr_accessor :test_suite, :test_index, :ws_config
    
    protected
    def save_web_service_result(data)
      Dir.mkdir 'tmp' unless File.exist? 'tmp'
      file_name = "tmp/#{@test_suite.source.sub(ENV['ws.test.models.path'] + '/', '')}_#{@count}.xml"
      @logger.info "Web service response saved to #{file_name}"
    
      File.open(file_name, 'w') {|file| file.write data }
      file_name
    end
    
    def validate_test_execution(expected_output, outcoming_file)
      return TestStatus.new :error => false if expected_output.nil?
      
      begin
        res = {}
        
        if expected_output['file']
          file = if expected_output['file'].start_with?(ENV['ws.test.output.files.path'])
             expected_output['file']
          else
            "#{ENV['ws.test.output.files.path']}/#{expected_output['file']}"
          end
          res[:file] = TestAssertion.compare_file file, outcoming_file
        end
        
        if expected_output['text']
          assertion = case output['text']
            when 'equals' then :equals
            when 'contains' then :contains
            when 'not_contains' then :not_contains
            when 'regex' then :regex
            else nil
          end
          
          res[:text] = TestAssertion.compare_text expected_output['text'], File.read(outcoming_file), assertion
        end
        
        return TestStatus.new :test_file_status => res[:file], :test_text_status => res[:text]
      rescue Exception => ex
        stack = ex.backtrace.join "\n"
        @logger.warn "Test validation has failed for test ##{@count}: #{ex.to_s}\n#{stack}"
        
        return ex
      end
    end
    
    def before(&block)
      @logger.info 'Playing Before Test'
      block.call if block_given?
    end
    
    def after(&block)
      @logger.info 'Playing After Test'
      block.call if block_given?
    end
  
  end

end
