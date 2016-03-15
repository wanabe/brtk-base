class Brtk
  module Base
    class Widget
      attr_accessor :widget

      def initialize(brtk)
        @brtk = brtk
        @brtk[self.class] = self
        @widget = self.class.widget_klass.new(*self.class.widget_args)
        self.class.child_classes.each do |child_class|
          add child_class.new(brtk)
        end
        setup
      end

      def add(other)
        widget.add other.widget
      end

      def setup
      end

      def run
      end

      class << self
        attr_reader :widget_klass, :widget_args, :child_names
        def widget(widget_klass, *widget_args)
          @widget_klass, @widget_args = widget_klass, widget_args
        end

        def child(name)
          return if @child_names.include? name
          @child_names << name
        end

        def child_classes
          @child_classes ||= @child_names.map do |child_name|
            name = child_name.to_s
            name.gsub!(/(?:^|_)([a-z])/) { $1.upcase }
            Brtk.const_get name
          end
        end

        def inherited(klass)
          klass.init
        end

        def init
          @child_names = []
        end
      end
    end

    class Layout < Widget
      def add(other)
        pack_start other, true, true, 2
      end

      def pack_start(other, *args)
        widget.pack_start other.widget, *args
      end
    end
  end
end
