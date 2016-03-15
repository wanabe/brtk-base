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
        define_signal_handlers
      end

      def add(other)
        widget.add other.widget
      end

      def setup
      end

      def define_signal_handlers
        self.class.signal_handlers.each do |signal, meth|
          widget.signal_connect(signal) do |*args|
            __send__ meth, *args
          end
        end
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

        def init
          @child_names = []
        end

        def inherited(klass)
          klass.init
        end

        def signal_handlers
          @signal_handlers ||= instance_methods.each_with_object({}) do |method_name, table|
            name = method_name.to_s
            signal = name[/^on_(\w*)/, 1]
            if signal
              table[signal] = method_name
            end
          end
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
