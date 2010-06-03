module Integrity
  module Views
    class Layout < Mustache
      include Integrity::Helpers

      def options
        Integrity::App
      end

      # TODO
      attr_reader :request

      def page_title
        "#{@title.last} | integrity"
      end

      def stylesheets
        %w[reset buttons integrity].map { |stylesheet|
          {:url => path("#{stylesheet}.css")}
        }
      end

      def content_title
        @title.join " / "
      end

      def not_authorized?
        ! authorized?
      end
    end
  end
end
