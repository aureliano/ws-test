require 'test/unit'
require File.expand_path '../../../../lib/model/test_suite_result.rb', __FILE__
require File.expand_path '../../../../lib/model/test_result.rb', __FILE__

class TestTestSuiteResult < Test::Unit::TestCase

  include Theotokos::Model
  
  def test_calculate_totals
    suite = TestSuiteResult.new
    suite.test_results = _prepare_data
    
    suite.calculate_totals
    
    assert_equal 7, suite.total_failures
    assert_equal 24, suite.total_success
    assert_equal 31, suite.total_tests
  end
  
  def test_result
    suite = TestSuiteResult.new
    suite.test_results = _prepare_data_to_success
    
    suite.calculate_totals
    assert suite.success?
    
    suite.test_results = _prepare_data_to_error
    suite.calculate_totals
    assert suite.error?
  end
  
  private
  def _prepare_data
    res = 10.times.map do
      TestResult.new do |t|
        t.status = TestStatus.new :test_file_status => true
      end
    end
    
    14.times.map do
      res << TestResult.new do |t|
        t.status = TestStatus.new :test_text_status => { :equals => true }
      end
    end
    
    5.times.map do
      res << TestResult.new do |t|
        t.status = TestStatus.new :test_file_status => { :equals => false }
      end
    end
    
    2.times.map do
      res << TestResult.new do |t|
        t.status = TestStatus.new :test_text_status => { :equals => false }
      end
    end
    
    res
  end
  
  def _prepare_data_to_success
    10.times.map do
      TestResult.new do |t|
        t.status = TestStatus.new :test_file_status => true
      end
    end
  end
  
  def _prepare_data_to_error
    5.times.map do
      TestResult.new do |t|
        t.status = TestStatus.new :test_file_status => false
      end
    end
  end
  
end
