require "graphviz"

module Waypoints
  module Tracer
    class << self
      def rootpath
        Regexp.new("^#{Rails.root}/").freeze
      end

      def key(event)
        klass = event.defined_class.to_s
        method = event.method_id
        action =
          if event.self.instance_of? Class
            "#{event.self}.#{method}"
          else
            "#{event.self.class}##{method}"
          end

        path = event.path.gsub(rootpath, "")
        line = event.lineno
        location =
          if rootpath.match? event.path
            "#{path}:#{line}"
          else
            nil
          end

        if klass == "ActionView::CompiledTemplates"
          action = nil
          location = path
        end

        [action, location].compact.join("|")
      end

      def trace?(event)
        return true if rootpath.match? event.path

        false
      end

      def trace(filepath)
        graph = GraphViz.new :G, type: :digraph

        graph.node[:fontname] = "Arial, Helvetica, SansSerif"
        graph.node[:style] = "rounded, filled"
        graph.node[:color] = "#000000"
        graph.node[:fillcolor] = "#FFFFFF"
        graph.node[:fontcolor] = "#000000"

        graph.edge[:fontname] = "Helvetica Neue Thin, Helvetica, Arial, SansSerif"
        graph.edge[:fontsize] = 12

        stack = []
        roots = []
        nodes = {}

        request = graph.add_node "Request", shape: "circle"

        trace = TracePoint.new :call, :return do |event|
          next unless trace? event

          case event.event
          when :return
            stack.pop

          when :call
            caller =
              if stack.last
                nodes.fetch stack.last do |_key|
                  nodes[_key] = graph.add_node _key, shape: "record"
                end
              end

            callee =
              if key(event)
                nodes.fetch key(event) do |_key|
                  nodes[_key] = graph.add_node _key, shape: "record"
                end
              end

            graph.add_edge caller, callee if caller && callee

            roots << callee if stack.empty?
            stack << key(event)
          end
        end

        trace.enable
        result = yield
        trace.disable

        roots.each do |root|
          graph.add_edge request, root
        end

        graph.output png: filepath

        result
      end
    end
  end
end
