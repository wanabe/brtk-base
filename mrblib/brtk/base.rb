class Brtk
  module Base
    class Widget
      attr_accessor :widget

      def initialize(brtk)
        @brtk = brtk
        @brtk[self.class] = self
      end

      def children
        @children ||= []
      end

      def add(other)
        children << other
        widget.add other.widget
      end

      def setup(klass, *args)
        @widget = klass.new(*args)
      end
    end

    class Layout < Widget
      def pack_start(other, *args)
        children << other
        widget.pack_start other.widget, *args
      end
    end
  end
end
