require 'fastlane/action'
require_relative '../helper/xcodebuildonlytesting_helper'

module Fastlane
  module Actions
    class XcodebuildonlytestingAction < Action
      def self.run(params)
        UI.message("The xcodebuildonlytesting plugin is working!")

        report_file = File.open(params[:reportLocation]) { |f| REXML::Document.new(f) }

        FastlaneCore::UI.user_error!("Malformed XML test report file given") if report_file.root.nil?
        FastlaneCore::UI.user_error!("Valid XML file is not an Xcode test report") if report_file.get_elements('testsuites').empty?

        failingTests = []
        report_file.elements.each('testsuites') do |testsuites_element|
          
          testsuites_element.elements.each('testsuite') do |testsuite_element|
            testsuiteName = testsuite_element.attribute('name').value
            UI.message("testsuite: #{testsuiteName}".green)
            
            testsuite_element.elements.each('testcase') do |testcase_element|
              className = testcase_element.attribute('classname').value
              testName = testcase_element.attribute('name').value
              testName.slice!('()')

              failure = testcase_element.elements['failure']
              if failure 
                UI.message(" NOK: #{className} - #{testName}".red)
                failingTests << "#{testsuiteName}/#{className}/#{testName}"
              else
                UI.message(" OK: #{className} - #{testName}".green)
              end
            end
          end
        end
        
        return failingTests
      end

      def self.description
        "Creates a array of tests from a junit to feed the xcodebuild only-testing"
      end

      def self.authors
        ["Luís Esteves"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Creates a array of tests from a junit to feed the xcodebuild only-testing[C"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :reportLocation,
                                       description: "junit report location",
                                       optional: false),
        ]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
