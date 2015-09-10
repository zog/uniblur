module ToggleHelper
  def toggle_action(resource, name, options={}, &block)
    build_toggle :link_to, resource, name, options, &block
  end

  def toggle_pill(resource, name, options={}, &block)
    build_toggle :pill, resource, name, options, &block
  end

  def build_toggle(method, resource, name, options={}, &block)
    options[:prefix] ||= 'un'

    off = options.delete(:off) || "#{options[:prefix]}#{name}"
    past_tense = name.verb.conjugate tense: :past, aspect: :perfective
    bool_attr = :"#{past_tense}?"

    is_on = resource.send(bool_attr)

    if is_on
      if can?(off, resource)
        send method, controller.resource_path_for(resource, off), method: :put, class: 'btn btn-warning', data: {confirm: "confirmations.#{controller.resource_name}.#{off}".t} do
          block.call(is_on)
        end
      end
    else
      if can?(name, resource)
        send method, controller.resource_path_for(resource,name), method: :put, class: 'btn btn-success', data: {confirm: "confirmations.#{controller.resource_name}.#{name}".t} do
          block.call(is_on)
        end
      end
    end
  end
end
