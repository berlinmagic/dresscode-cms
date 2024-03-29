# encoding: utf-8
## => inspired by Spree  (  https://github.com/spree/spree  &  http://spreecommerce.com/  )  ... thanks a lot !!!
module HookSupport

  # A hook modifier is created for each usage of 'insert_before','replace' etc.
  # This stores how the original contents of the hook should be modified
  # and does the work of altering the hooks content appropriately
  class HookModifier
    attr_accessor :hook_name
    attr_accessor :action
    attr_accessor :renderer

    def initialize(hook_name, action, renderer = nil)
      @hook_name = hook_name
      @action = action
      @renderer = renderer
    end

    def apply_to(content, context, locals = {})
      return '' if renderer.nil?
      case action
      when :insert_before
        "#{renderer.call(context, locals)}#{content}".html_safe
      when :insert_after
        "#{content}#{renderer.call(context, locals)}".html_safe
      when :replace
        renderer.call(context, locals).to_s.html_safe
      else
        ''
      end
    end

  end

end