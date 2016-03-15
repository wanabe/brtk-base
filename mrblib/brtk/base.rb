class Brtk
  module Base
    class Widget
      attr_accessor :widget

      def initialize(brtk)
        @brtk = brtk
        @brtk[self.class] = self
        @widget = self.class.widget_klass.new(*self.class.widget_args)
      end

      def children
        @children ||= []
      end

      def add(other)
        children << other
        widget.add other.widget
      end

      class << self
        attr_reader :widget_klass, :widget_args
        def widget(widget_klass, *widget_args)
          @widget_klass, @widget_args = widget_klass, widget_args
        end
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
