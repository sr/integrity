module Integrity
  module Views
    class Fork < Mustache
      include Integrity::Helpers

      def request
        @request
      end

      def form_action
        project_path(@project, :fork).to_s
      end
    end
  end
end
