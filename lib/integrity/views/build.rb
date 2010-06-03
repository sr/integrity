module Integrity
  module Views
    # TODO
    class BuildView < Layout
      def css_class
        @build.status.to_s
      end

      def form_action
        build_path(@build)
      end

      def status
        @build.human_status
      end

      def form_rebuild_url
        build_path(@build)
      end

      def commit_message
        @build.commit.message
      end

      def commit_author
        @build.commit.author.name
      end

      def commit_date
        @build.commit.committed_at
      end

      def commit_date_pretty
        pretty_date(commit_date)
      end

      def github?
        @build.project.github?
      end

      def github_url
        github_commit_url(@build.commit)
      end

      def completed?
        @build.completed?
      end

      def output
        bash_color_codes(@build.output)
      end
    end
  end
end
