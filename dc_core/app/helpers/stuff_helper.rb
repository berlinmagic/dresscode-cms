# encoding: utf-8
module StuffHelper
  
  def the_std_actions( objekt, view='index' )
    action = []
    trenner = "&nbsp;&nbsp;&#10072;&nbsp;&nbsp;"
    action << link_to("Anzeigen", objekt) if view == 'index'
    action << link_to("Liste", objekt.class) if view == 'show'
    action << link_to("Bearbeiten", [:edit, objekt])
    action << link_to("Löschen", objekt, :confirm => 'Are you sure?', :method => :delete)
    return action.join(trenner)
  end
  
  def the_actions( objekt, view='index' )
    action = []
    trenner = "&nbsp;&nbsp;&#10072;&nbsp;&nbsp;"
    action << link_to("Anzeigen", [:dc, objekt]) if view == 'index'
    action << link_to("Liste", [:dc, objekt.class]) if view == 'show'
    action << link_to("Bearbeiten", [:edit, :dc, objekt])
    action << link_to("Löschen", [:dc, objekt], :confirm => 'Are you sure?', :method => :delete)
    return action.join(trenner)
  end
  
  def cms_tag( *args, &block )
    options = args.extract_options!
    object = args.first
    this_class = "tl_element #{args.first.class.to_s.downcase} "
    content_tag(  options[:element], 
                  :class => (this_class + options[:class]), 
                  :data => options[:data],
                  :id => options[:id], 
                  &block  )
  end
  
  def view_tag( *args, &block )
    options = args.extract_options!
    object = args.first
    content_tag(  options[:element], 
                  :class => options[:class], 
                  :data => options[:data],
                  :id => options[:id], 
                  &block  )
  end
  
  
  def title(page_title, show_title = true)
    content_for(:title) { h("suitUp-2 | #{page_title.to_s}") }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  
  # Render error messages for the given objects. The :message and :header_message options are allowed.
  def error_messages_for(*objects)
    options = objects.extract_options!
    options[:header_message] ||= I18n.t(:"activerecord.errors.header", :default => "Invalid Fields")
    options[:message] ||= I18n.t(:"activerecord.errors.message", :default => "Correct the following errors and try again.")
    messages = objects.compact.map { |o| o.errors.full_messages }.flatten
    unless messages.empty?
      content_tag(:div, :class => "error_messages") do
        list_items = messages.map { |msg| content_tag(:li, msg) }
        content_tag(:h2, options[:header_message]) + content_tag(:p, options[:message]) + content_tag(:ul, list_items.join.html_safe)
      end
    end
  end

  module FormBuilderAdditions
    def error_messages(options = {})
      @template.error_messages_for(@object, options)
    end
  end
end

ActionView::Helpers::FormBuilder.send(:include, StuffHelper::FormBuilderAdditions)
