module Integrity
  module Views
    class Fork < Layout
      def form_action
        project_path(@project, :fork).to_s
      end
    end
  end
end
