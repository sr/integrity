module Integrity
  module Views
    # TODO
    class Home < Layout
      def empty?
        @projects.empty?
      end

      def any?
        ! empty?
      end

      # TODO helper
      def new_path
        path("new")
      end

      def projects
        @projects.map { |project|
          status =
            case project.status
            when :building
              "Building!"
            when :blank
              "Never built yet"
            end

          { :class     => "#{cycle("even", "odd")} #{project.status}",
            :path      => project_path(project),
            :name      => project.name,
            :status    => status }
        }
      end
    end
  end
end
