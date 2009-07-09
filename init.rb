module Nakajima
  module BetterEditInPlace
    def edit_in_place(resource, field, options={})
      # Get record to be edited. If resource is an array, pull it out.
      record = resource.is_a?(Array) ? resource.last : resource

      options[:id]  ||= "#{dom_id(record)}_#{field}"
      options[:tag] ||= :span
      options[:url] ||= url_for(resource)
      options[:rel] ||= options.delete(:url)
      options.delete(:url) # Just in case it wasn't cleared already

      classes = options[:class].split(' ') rescue []
      classes << 'editable' if classes.empty?
      options[:class] = classes.uniq.join(' ')

      sudoElement(options, record.send(field)) +
        content_tag(options.delete(:tag), record.send(field), options) +
        javascript_tag("new Editable('#{options[:id]}', '#{getSudoId(options[:id])}')")
    end

    def sudoElement(options, value)
      unless value.blank?
        value = nil
      else
        value = "Not Set"
      end
      content_tag(:span, value, :id => getSudoId(options[:id])) 
    end

    def getSudoId(value)
      return "sudo_" + value
    end
  end  
end

ActionView::Base.send :include, Nakajima::BetterEditInPlace
ActionController::Base.send :include, BetterEditInPlace
