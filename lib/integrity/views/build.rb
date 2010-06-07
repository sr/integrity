module Integrity
  module Views
    # TODO
    class BuildView < Layout
      attr_reader :build

      def css_build_status
        build.status.to_s
      end

      def destroy_path
        build_path(build)
      end

      def build_status
        build.human_status
      end

      def rebuild_path
        build_path(build)
      end

      def commit_message
        build.commit.message
      end

      def commit_author
        build.commit.author.name
      end

      def commit_date
        build.commit.committed_at
      end

      def commit_date_pretty
        pretty_date(commit_date)
      end

      def github?
        build.project.github?
      end

      def build_github_url
        github_commit_url(build.commit)
      end

      def build_completed?
        build.completed?
      end

      def build_output
        bash_color_codes(build.output)
      end

      def projet_github?
        build.project.github?
      end
    end
  end
end
