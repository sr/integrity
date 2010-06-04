module Integrity
  module Views
    # TODO move to layout
    class NotFound < Layout
      def back
        request.referer
      end
    end
  end
end
