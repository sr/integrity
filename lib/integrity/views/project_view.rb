module Integrity
  module Views
    # TODO
    class ProjectView < BuildView
      def build
        @project.last_build
      end

      def edit_path
        project_path(@project, :edit).to_s
      end

      def fork_path
        project_path(@project, :fork).to_s
      end

      def github?
        @project.github?
      end

      # TODO
      def project_github_url
        github_project_url(@project)
      end

      def blank?
        @project.blank?
      end

      def not_blank?
        ! blank?
      end

      def create_build_path
        project_path(@project, :builds).to_s
      end

      def last_build_class
        @project.last_build.status.to_s
      end

      def builds
        @project.sorted_builds.map { |build|
          { :class  => build.status.to_s,
            :path   => build_path(build),
            :sha1   => build.commit.short_identifier,
            :author => build.commit.author.name,
            :when   => pretty_date(build.commit.committed_at) }
        }
      end
    end
  end
end
