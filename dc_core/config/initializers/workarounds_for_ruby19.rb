# encoding: utf-8
## => inspired by Spree  (  https://github.com/spree/spree  &  http://spreecommerce.com/  )  ... thanks a lot !!!
# => https://github.com/spree/spree/blob/master/core/config/initializers/workarounds_for_ruby19.rb
# => Thanks a Lot to  Railsdog & Co.
if RUBY_VERSION.to_f >= 1.9

  class String
    def mb_chars
      self.force_encoding(Encoding::UTF_8)
    end

    alias_method(:orig_concat, :concat)
    def concat(value)
      orig_concat value.frozen? || !value.respond_to?(:force_encoding) ? value : value.force_encoding(Encoding::UTF_8)
    end
  end

  module ActionView
    module Renderable #:nodoc:
      private
        def compile!(render_symbol, local_assigns)
          locals_code = local_assigns.keys.map { |key| "#{key} = local_assigns[:#{key}];" }.join

          source = <<-end_src
            def #{render_symbol}(local_assigns)
              old_output_buffer = output_buffer;#{locals_code};#{compiled_source}
            ensure
              self.output_buffer = old_output_buffer
            end
          end_src
          source.force_encoding(Encoding::UTF_8) if source.respond_to?(:force_encoding)

          begin
            ActionView::Base::CompiledTemplates.module_eval(source, filename, 0)
          rescue Errno::ENOENT => e
            raise e # Missing template file, re-raise for Base to rescue
          rescue Exception => e # errors from template code
            if logger = defined?(ActionController) && Base.logger
              logger.debug "ERROR: compiling #{render_symbol} RAISED #{e}"
              logger.debug "Function body: #{source}"
              logger.debug "Backtrace: #{e.backtrace.join("\n")}"
            end

            raise ActionView::TemplateError.new(self, {}, e)
          end
        end
    end
  end

  if defined?(Mysql::Result)
    class Mysql::Result
      def encode(value, encoding = "utf-8")
        String === value ? value.force_encoding(encoding) : value
      end

      def each_utf8(&block)
        each_orig do |row|
          yield row.map {|col| encode(col) }
        end
      end
      alias each_orig each
      alias each each_utf8

      def each_hash_utf8(&block)
        each_hash_orig do |row|
          row.each {|k, v| row[k] = encode(v) }
          yield(row)
        end
      end
      alias each_hash_orig each_hash
      alias each_hash each_hash_utf8
    end
  end
  
  # => Hier ein paar vorher getätigte Versuche :
  # => 
  # => Encoding.default_external="UTF-8"          # => an verscheidensten Stellen
  # => 
  # => - Make sure 'config.encoding = "utf-8"' is there in application.rb file.
  # => - Make sure you are using 'mysql2' gem
  # => - Putting '# encoding: utf-8' on top of file containing utf-8 characters.
  # => - Above '<App Name>::Application.initialize!' line in environment.rb file, add following two lines:
  # => 
  # => Encoding.default_external = Encoding::UTF_8
  # => Encoding.default_internal = Encoding::UTF_8
  # => 
  # => config.encoding = "utf-8"                  # =>in production.rb
  # => 
  # => initializer "strange.app.configurator" do |app|                                                                      # => in strange_core/railtie.rb
  # =>   app.config.time_zone = "#{ DC::Config[:time_zone].blank? ? 'Berlin' : DC::Config[:time_zone] }"
  # =>   app.config.i18n.default_locale = DC::Config[:default_locale]
  # =>   app.config.encoding = "utf-8"
  # => end
  # => 

end
