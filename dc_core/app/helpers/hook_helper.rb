# encoding: utf-8
module HookHelper
  
  #   #   #   #   #   #   #   #   #   #   #   #   # 
  # > Allow hooks to be used in views like this:
  #   <%= hook :some_hook %>
  #   or:
  #   <%= hook :some_hook do %>
  #     <p>Some HTML</p>
  #   <% end %>
  #   #   #   #   #   #   #   #   #   #   #   #   #
  
  def hook(hook_name, locals = {}, &block)
    content = block_given? ? capture(&block) : ''
    HookSupport::Hook.render_hook(hook_name, content, self, locals)
  end

  def locals_hash(names, binding)
    names.inject({}) {|memo, key| memo[key.to_sym] = eval(key, binding); memo}
  end

end