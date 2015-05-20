module Xcode

  class Workspace
    def to_xcodebuild_option
      "-workspace \"#{self.path}\""
    end
  end

  class Project
    def to_xcodebuild_option
      "-project \"#{self.path}\""
    end
  end

  module Builder
    class SchemeBuilder < BaseBuilder

      def initialize(scheme)
        @scheme     = scheme
        @target     = @scheme.build_targets.last
        super @target, @target.config(@scheme.archive_config)
      end

      def prepare_xcodebuild sdk=@sdk
        cmd = super sdk
        cmd << @scheme.parent.to_xcodebuild_option
        cmd << "-scheme \"#{@scheme.name}\""
        cmd << "-configuration \"#{@scheme.archive_config}\""
        cmd
      end

      def prepare_test_command sdk=@sdk
        cmd = prepare_xcodebuild sdk
        cmd << "test"
        cmd
      end
      
      def test options = {:sdk => @sdk, :show_output => false}
        unless @scheme.testable?
          print_task :builder, "Nothing to test", :warning        
        else
          super options
        end
      end

    end
  end
end
