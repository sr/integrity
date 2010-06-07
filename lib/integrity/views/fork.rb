module Integrity
  module Views
    class Fork < Layout
      def fork_path
        project_path(@project, :fork).to_s
      end
    end
  end
end
